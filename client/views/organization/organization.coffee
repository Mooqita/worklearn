###############################################################################
# import
###############################################################################

###############################################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter

###############################################################################
# Organizations
###############################################################################

###############################################################################
Template.organizations.helpers
	need_to_register:() ->
		n_org = get_admissions(IGNORE, IGNORE, Organizations, IGNORE)

		if n_org.count() > 0
			return false

		return true

	onboarding_url:() ->
		url = build_url "onboarding_job_role", {}, "onboarding"
		return url

###############################################################################
Template.organizations.events
	"click #get_started": () ->
		url = build_url "onboarding_job_role", {}, "onboarding"
		FlowRouter.redirect(url)


###############################################################################
# Organization Preview
###############################################################################

###############################################################################
Template.organization_preview.helpers
	org_name: () ->
		inst = Template.instance()
		data = inst.data
		if data.name
			return data.name

		return "Your company does not yet have a name."

	org_description: () ->
		inst = Template.instance()
		data = inst.data
		if data.description
			return data.description

		return "Your company does not yet have a description."


###############################################################################
# Organization Profile
###############################################################################

###############################################################################
Template.organization.onCreated ->
	self = this
	self.autorun () ->
		organization_id = FlowRouter.getQueryParam("organization_id")
		self.subscribe "organization_by_id", organization_id


###############################################################################
Template.organization.helpers
	organization: () ->
		id = FlowRouter.getQueryParam("organization_id")
		return Organizations.findOne(id)


###############################################################################
Template.organization.events
	"click #add_member": (event) ->
		mails = Template.instance().find("#mails").value
		profile = get_profile()
		mails =
			email: mails
			role: OWNER

		Meteor.call "add_admissions", "profiles", profile._id, [mails],
			(res, err) ->
				if err
					sAlert.error(err)
				else
					sAlert.suc cess("Invitation send.")


