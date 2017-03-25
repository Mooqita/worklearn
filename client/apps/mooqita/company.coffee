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
		console.log self
		self.subscribe "responses_by_group", "challenge"

########################################
Template.company_challenges.helpers
	challenges: () ->
		filter =
			group_name: "challenge"

		return Responses.find(filter)

########################################
Template.company_challenges.events
	"click #add_challenge": () ->
		filter =
			parent_id: this._id
			template_id: "challenge"

		index = Responses.find(filter).count()
		Meteor.call "add_response", "challenge", index, this._id

########################################
#
# challenge_preview
#
########################################

########################################
Template.challenge_preview.helpers
	challenge_url:()->
		return get_response_url this._id, true


########################################
#
# challenge
#
########################################

########################################
Template.challenge.helpers
	challenge_url:()->
		return get_response_url this._id, true

########################################
Template.challenge.events
	"click #icon_download": (e, n)->
		if document.selection
			range = document.body.createTextRange()
			range.moveToElementText(document.getElementById('challenge_url'))
			range.select()
		else if window.getSelection
			range = document.createRange()
			range.selectNodeContents(document.getElementById('challenge_url'))
			selection = window.getSelection()
			selection.removeAllRanges()
			selection.addRange(range)

		return true
