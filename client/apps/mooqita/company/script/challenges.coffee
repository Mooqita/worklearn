########################################
#
# company challenges view
#
########################################

########################################
Template.company_challenges.onCreated ->
	Session.set "selected_challenge", 0
	self = this

	self.autorun ->
		Meteor.subscribe "my_challenges"


########################################
Template.company_challenges.helpers
	challenges: () ->
		filter =
			owner_id: Meteor.userId()
			type_identifier: "challenge"

		return Responses.find(filter)

########################################
Template.company_challenges.events
	"click #add_challenge": () ->
		Meteor.call "add_challenge",
			(err, res) ->
				if err
					sAlert.error(err)


########################################
#
# challenge_preview
#
#########################################

########################################
Template.challenge_preview.helpers
	title: () ->
		if this.title
			return this.title

		return "This challenge does not yet have a title."

	content: () ->
		if this.content
			return this.content

		return "No description available, yet."

########################################
Template.challenge_preview.events
	"click #company_challenge": () ->
		param =
			challenge_id: this._id
			template: "company_challenge"
		FlowRouter.setQueryParams param


########################################
#
# challenge
#
########################################

########################################
Template.company_challenge.onCreated ->
	self = this
	self.autorun ->
		id = FlowRouter.getQueryParam("challenge_id")
		if not id
			return
		self.subscribe "my_challenge_by_id", id


########################################
Template.company_challenge.helpers
	challenge: () ->
		id = FlowRouter.getQueryParam("challenge_id")
		return Responses.findOne id

	publish_disabled: () ->
		data = Template.currentData()
		content = get_field_value data, "content", data._id, "Responses"

		if not content
			return "disabled"

		published = get_field_value data, "published", data._id, "Responses"
		if published
			return "disabled"

		return ""

	share_url: ->
		url = "user?template=student_solution&challenge_id=" + this._id
		url = Meteor.absoluteUrl(url)
		return url

########################################
Template.company_challenge.events
	"click #icon_download": (e, n)->
		if document.selection
			range = document.body.createTextRange()
			range.moveToElementText(document.getElementById("challenge_url"))
			range.select()

		else if window.getSelection
			range = document.createRange()
			range.selectNodeContents(document.getElementById("challenge_url"))
			selection = window.getSelection()
			selection.removeAllRanges()
			selection.addRange(range)

		return true

	"click #publish": ()->
		if event.target.attributes.disabled
			return

		Meteor.call "finish_challenge", this._id,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success "Challenge published!"


########################################
#
# challenge solutions
#
########################################

########################################
Template.challenge_solutions.onCreated ->
	Session.set "selected_review", 0
	self = this

	self.autorun () ->
		id = FlowRouter.getQueryParam("challenge_id")
		self.subscribe 'challenge_summary', id

########################################
Template.challenge_solutions.helpers
	challenge_summary: () ->
		return Challenge_Summary.find()

########################################
#
# challenge solutions
#
########################################

########################################
Template.challenge_solution.onCreated ->
	this.reviews_visible = new ReactiveVar(false)

########################################
Template.challenge_solution.helpers
	resume_url: (author_id) ->
		return author_id

	reviews: (id) ->
		return this.reviews

	reviews_visible: ->
		return Template.instance().reviews_visible.get()


########################################
Template.challenge_solution.events
	"click #show_reviews": ->
		f = Template.instance().reviews_visible.get()
		Template.instance().reviews_visible.set !f
