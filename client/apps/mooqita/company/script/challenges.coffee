########################################
#
# company challenges view
#
########################################

########################################
Template.company_challenges.onCreated ->
	Session.set "selected_challenge", 0

########################################
Template.company_challenges.helpers
	challenges: () ->
		filter =
			type_identifier: "challenge"

		return Responses.find(filter)

########################################
Template.company_challenges.events
	"click #add_challenge": () ->
		filter =
			parent_id: this._id
			template_id: "challenge"

		index = Responses.find(filter).count()

		param =
			name: "user generated challenge: " + index
			index: index
			parent_id: this._id
			template_id: "challenge"
			type_identifier: "challenge"

		Meteor.call "add_response", param,
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
	has_more: () ->
		if this.content
			return this.content.length>250

		return false

	selected: ->
		return this._id==Session.get "selected_challenge"

	title: () ->
		if this.title
			return this.title

		return "This challenge does not yet have a title."

	content: () ->
		if this._id==Session.get "selected_challenge"
			return this.content

		if this.content
			return this.content.substring(0, 250)

		return "No description available, yet."

########################################
Template.challenge_preview.events
	"click #company_challenge": () ->
		Session.set "company_data", this
		Session.set "company_template", "company_challenge"

########################################
#
# challenge
#
########################################

########################################
Template.company_challenge.onCreated ->

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

########################################
#
# challenge solutions
#
########################################

########################################
Template.challenge_solutions.onCreated ->
	self = this

	Session.set "selected_review", 0

	self.autorun () ->
		self.subscribe 'challenge_summary', self.data._id

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
Template.challenge_solution.helpers
	content: () ->
		if this._id==Session.get "selected_review"
			return this.content

		return this.content.substring(0, 250)

	resume_url: (author_id) ->
		return author_id

	reviews: (id) ->
		return this.reviews

	selected: ->
		return this._id==Session.get "selected_review"

########################################
Template.challenge_solution.events
	"click #select": ->
		f = Session.get "selected_review"
		m = this._id

		if f==m
			Session.set "selected_review", 0
		else
			Session.set "selected_review", this._id
