##########################################################
# local variables and methods
##########################################################

##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


########################################
# All my invitations I received
########################################

########################################
Template.invitations.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe "received_invitations"

########################################
Template.invitations.helpers
	invitations: () ->
		return Invitations.find()


########################################
# A single invitation
########################################

########################################
Template.invitation.onCreated ->
	self = this
	self.autorun () ->
		id = FlowRouter.getQueryParam("invitation_id")
		self.subscribe "invitation_by_id", id

		id = FlowRouter.getQueryParam("organization_id")
		self.subscribe "organization_by_id", id

########################################
Template.invitation.helpers
	invitation: () ->
		id = FlowRouter.getQueryParam("invitation_id")
		inv = Invitations.findOne id
		return inv

	organization: () ->
		id = FlowRouter.getQueryParam("organization_id")
		org = Organizations.findOne id
		return org

	invite_url: () ->
		query =
			invitation_id: FlowRouter.getQueryParam("invitation_id")
			organization_id: FlowRouter.getQueryParam("organization_id")

		url = build_url "invitation", query
		return url


########################################
Template.invitation.events
	"click #accept": () ->
		invitation_id = FlowRouter.getQueryParam "invitation_id"

		Meteor.call "accept_invitation", invitation_id,
			(res, err) ->
				console.log res
				console.log err
				#FlowRouter.go "onboarding_finish"

	"click #register": () ->
		inst = Template.instance()
		password = inst.find("#at-field-password").value
		invitation_id = FlowRouter.getQueryParam "invitation_id"

		Meteor.call "register_to_accept_invitation", invitation_id, password,
			(res, err) ->
				console.log res
				console.log err
				#FlowRouter.go "onboarding_finish"

