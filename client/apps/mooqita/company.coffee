########################################
#
# company view
#
########################################

########################################
Template.company_view.helpers
	challenges: () ->
		filter =
			parent_id: this._id
			template_id: "challenge"

		return Responses.find(filter)


########################################
Template.company_view.events
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
		return FlowRouter.path "response.id",
			response_id: this._id


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
