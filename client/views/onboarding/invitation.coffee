###############################################################################
# local variables and methods
###############################################################################

###############################################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


###############################################################################
# All my invitations I received
###############################################################################

###############################################################################
Template.invitations.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe "received_invitations"

###############################################################################
Template.invitations.helpers
	invitations: () ->
		return Invitations.find()


###############################################################################
# A single invitation
###############################################################################

###############################################################################
Template.invitation.onCreated ->
	self = this
	self.autorun () ->
		invitation_id = FlowRouter.getQueryParam("invitation_id")
		self.subscribe "invitation_by_id", invitation_id,
			(res, err) ->
				invite = Invitations.findOne invitation_id
				if invite.accepted
					query =
						invitation_id: FlowRouter.getQueryParam("invitation_id")
						organization_id: FlowRouter.getQueryParam("organization_id")
					url = build_url "invitation", query
					FlowRouter.go url

		organization_id = FlowRouter.getQueryParam("organization_id")
		self.subscribe "organization_by_id", organization_id

###############################################################################
Template.invitation.helpers
	invitation: () ->
		id = FlowRouter.getQueryParam("invitation_id")
		inv = Invitations.findOne id
		return inv

	organization: () ->
		id = FlowRouter.getQueryParam("organization_id")
		org = Organizations.findOne id
		return org


###############################################################################
# Accept invitation
###############################################################################

###############################################################################
Template.invitation_accept.events
	"click #accept": () ->
		invitation_id = FlowRouter.getQueryParam "invitation_id"
		Meteor.call "accept_invitation", invitation_id,
		(res, err) ->
			if err
				sAlert.error(err)
			FlowRouter.go build_url "personality"


###############################################################################
Template.invitation_accept.helpers
	invitation: () ->
		id = FlowRouter.getQueryParam("invitation_id")
		inv = Invitations.findOne id
		return inv

	organization: () ->
		id = FlowRouter.getQueryParam("organization_id")
		org = Organizations.findOne id
		return org


###############################################################################
# Register
###############################################################################

###############################################################################
Template.invitation_register.helpers
	invite_url: () ->
		query =
			invitation_id: FlowRouter.getQueryParam("invitation_id")
			organization_id: FlowRouter.getQueryParam("organization_id")

		url = build_url "invitation", query
		return url


###############################################################################
Template.invitation_register.helpers
	invitation: () ->
		id = FlowRouter.getQueryParam("invitation_id")
		inv = Invitations.findOne id
		return inv

	organization: () ->
		id = FlowRouter.getQueryParam("organization_id")
		org = Organizations.findOne id
		return org


###############################################################################
Template.invitation_register.events
	"click #register": () ->
		inst = Template.instance()
		email = inst.find("#at-field-mail").innerText
		password = inst.find("#at-field-password").value
		invitation_id = FlowRouter.getQueryParam "invitation_id"

		digested = Accounts._hashPassword password

		Meteor.call "register_to_accept_invitation", invitation_id, digested,
		(err, res) ->
			if err
				sAlert.error err
				return

			Meteor.loginWithPassword email, password,
				(err) ->
					if err
						sAlert.error err
						return

					FlowRouter.go build_url "personality"

