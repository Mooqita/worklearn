###############################################################################
#
# Onboarding
#
###############################################################################

###############################################################################
# local variables and methods
################################################################################

################################################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

################################################################################
_check_session = () ->
	if not Session.get "user_occupation"
		Session.set "user_occupation", "company"

	if not Session.get "onboarding_job_posting"
		Session.set "onboarding_job_posting", {}

	if not Session.get "onboarding_persona_data"
		Session.set "onboarding_persona_data", persona_job


################################################################################
# Onboarding Role
################################################################################

################################################################################
Template.onboarding_job_role.onCreated ->
	_check_session()
	#	FlowRouter.go "onboarding_job_intro"


################################################################################
# Onboarding Competency
################################################################################

################################################################################
Template.onboarding_job_competency.onCreated ->
	_check_session()
	#	FlowRouter.go "onboarding_job_intro"


################################################################################
Template.onboarding_job_competency.events
	"click .toggle-button": () ->
		instance = Template.instance()
		dict = Session.get "onboarding_job_posting"

		dict["idea"] = if instance.find("#idea_id").checked then 1 else 0
		dict["team"] = if instance.find("#team_id").checked then 1 else 0
		dict["process"] = if instance.find("#process_id").checked then 1 else 0
		dict["strategic"] = if instance.find("#strategic_id").checked then 1 else 0

		Session.set "onboarding_job_posting", dict


################################################################################
# Onboarding Finish
################################################################################

################################################################################
Template.onboarding_job_finish.onCreated ->
	self = this

	self.autorun ()->
		_check_session()
		self.subscribe "my_organizations"

		filter =
			collection_name: "jobs"
		admissions = Admissions.find(filter).fetch()

		self.subscribe "my_jobs", admissions


################################################################################
Template.onboarding_job_finish.onRendered ->
	Tracker.autorun () ->
		persona_data = persona_build Session.get "onboarding_job_posting"
		Session.set "onboarding_job_persona_data", persona_data


################################################################################
Template.onboarding_job_finish.helpers
	persona_data: () ->
		return Session.get "onboarding_job_persona_data"

	user_profile: () ->
		profile = undefined
		user_id = Meteor.userId()

		if user_id
			profile = Profiles.findOne {user_id: user_id}

		return profile


	organization_profile: () ->
		profile = Organizations.findOne()
		return profile


	job_id: () ->
		job = Jobs.findOne()
		if not job
			return undefined
		return job._id


################################################################################
Template.onboarding_job_finish.events
	"click #register":()->
		Modal.show 'onboarding_job_register'


################################################################################
# Onboarding register
################################################################################

################################################################################
Template.onboarding_job_register.onCreated ->
	AccountsTemplates.setState("signUp")

################################################################################
Template.onboarding_job_register.helpers
	has_profile: () ->
		profile = undefined
		user_id = Meteor.userId()

		if user_id
			profile = Profiles.findOne {user_id: user_id}

		return profile

################################################################################
# Overview after registration
################################################################################

################################################################################
Template.job_overview.helpers
	persona_data: () ->
		return Session.get "onboarding_job_persona_data"

	user_profile: () ->
		profile = undefined
		user_id = Meteor.userId()

		if user_id
			profile = Profiles.findOne {user_id: user_id}

		return profile


	organization_profile: () ->
		profile = Organizations.findOne()
		return profile


	job_id: () ->
		job = Jobs.findOne()
		if not job
			return undefined
		return job._id


################################################################################
Template.job_overview.onCreated () ->
	self = this
	data = Session.get "onboarding_job_posting"

	self.autorun ()->
		org_filter =
			collection_name: "organizations"
		org_admissions = Admissions.find(org_filter).fetch()

		job_filter =
			collection_name: "jobs"
		job_admissions = Admissions.find(job_filter).fetch()

		invite_filter =
			collection_name: "invitations"
		invite_admissions = Admissions.find(invite_filter).fetch()

		organization_id = ""
		if org_admissions.length > 0
			organization_id = org_admissions[0].resource_id
			self.data.organization_id = organization_id

		self.subscribe "send_invitations", invite_admissions
		self.subscribe "my_organizations", org_admissions
		self.subscribe "my_jobs", job_admissions

		if self.subscriptionsReady()
			if Organizations.find().count() == 0
				Meteor.call "onboard_organization", data


