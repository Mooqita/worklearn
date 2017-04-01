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
			index: index
			type: "challenge"
			name: "user generated challenge: " + index
			title: "user generated challenge: " + index
			template_id: "challenge"
			parent_id: this._id

		Meteor.call "add_response", "challenge", param,
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
