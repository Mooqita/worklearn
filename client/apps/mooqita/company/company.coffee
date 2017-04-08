########################################
#
# company view
#
########################################

########################################
Template.company_view.onCreated ->
	Session.set "company_template", "company_summary"

########################################
Template.company_view.helpers
	selected_view: () ->
		return Session.get "company_template"

########################################
Template.company_menu.events
	"click #company_summary": ()->
		Session.set "company_template", "company_summary"

	"click #company_challenges": ()->
		Session.set "company_template", "company_challenges"

########################################
#
# company challenges view
#
########################################

########################################
Template.company_challenges.onCreated ->
	self = this
	self.autorun () ->
		data = Template.currentData()

		filter =
			type_identifier: "challenge"
			owner_id: Meteor.userId()
			text: data.query

		self.subscribe "responses", filter, true, true, "company_challenges"

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
#
# challenge
#
########################################

########################################
Template.challenge.events
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
		self.subscribe 'peers_by_challenge', self.data._id

########################################
Template.challenge_solutions.helpers
	peers: () ->
		return Peers.find()

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

		return this.content.substring(1, 250)

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
