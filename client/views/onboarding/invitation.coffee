########################################
Template.invitation.onCreated ->


########################################
Template.invitation.helpers
	invitation_id: () ->
		id = FlowRouter.getQueryParam("invitation_id")
		return id

