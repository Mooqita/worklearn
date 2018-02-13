#########################################################
#
# Onboarding
#
#########################################################

##########################################################
# local variables and methods
##########################################################

##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

#########################################################
_check_session = () ->
	if not Session.get "user_occupation"
		Session.set "user_occupation", "company"

	if not Session.get "onboarding_job_posting"
		Session.set "onboarding_job_posting", {}

	if not Session.get "onboarding_persona_data"
		Session.set "onboarding_persona_data", persona_job


#########################################################
# Onboarding Role
#########################################################

#########################################################
Template.onboarding_role.onCreated ->
	_check_session()
	#	FlowRouter.go "onboarding_intro"


#########################################################
# Onboarding Competency
#########################################################

#########################################################
Template.onboarding_competency.onCreated ->
	_check_session()
	#	FlowRouter.go "onboarding_intro"


#########################################################
Template.onboarding_competency.events
	"click .toggle-button": () ->
		instance = Template.instance()
		dict = Session.get "onboarding_job_posting"

		dict["idea"] = if instance.find("#idea_id").checked then 1 else 0
		dict["team"] = if instance.find("#team_id").checked then 1 else 0
		dict["process"] = if instance.find("#process_id").checked then 1 else 0
		dict["strategic"] = if instance.find("#strategic_id").checked then 1 else 0

		Session.set "onboarding_job_posting", dict


#########################################################
# Onboarding Finish
#########################################################

#########################################################
Template.onboarding_finish.onCreated ->
	self = this

	self.autorun ()->
		self.subscribe "my_admissions"

		filter =
			collection_name: "jobs"
		admissions = Admissions.find(filter).fetch()

		self.subscribe "my_jobs", admissions,
			(err, res) ->
				#if Jobs.find().count() == 0
				_check_session()
				#		FlowRouter.go "onboarding_intro"


#########################################################
Template.onboarding_finish.onRendered ->
	Tracker.autorun () ->
		persona_data = persona_build Session.get "onboarding_job_posting"
		Session.set "onboarding_persona_data", persona_data


#########################################################
Template.onboarding_finish.helpers
	persona_data: () ->
		return Session.get "onboarding_persona_data"

	has_profile: () ->
		profile = undefined
		user_id = Meteor.userId()

		if user_id
			profile = Profiles.find {user_id: user_id}

		return profile


#########################################################
Template.onboarding_finish.events
	"click #register":()->
		Modal.show 'onboarding_register'


#########################################################
# Onboarding register
#########################################################

#########################################################
Template.onboarding_register.onCreated ->
	AccountsTemplates.setState("signUp")


#########################################################
Template.onboarding_register.helpers
	has_profile: () ->
		profile = undefined
		user_id = Meteor.userId()

		if user_id
			profile = Profiles.findOne {user_id: user_id}

		return profile


#########################################################
# Job posting
#########################################################

#########################################################
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


#########################################################
Template.job_overview.helpers
	jobs: () ->
		return Jobs.find()

	job_persona: (data) ->
		job = persona_build(data)
		return job

	team_persona: () ->
		members = TeamMembers.find().fetch()
		team = persona_extract_requirements(members)
		team = persona_map team, persona_map_person_to_job
		return team

	optimal_persona: (data) ->
		members = TeamMembers.find().fetch()
		team = persona_extract_requirements(members)
		if not team
			return undefined

		job = persona_build(data)
		res = persona_optimize_team(team, job)

		return res


#########################################################
Template.job_overview.events
	"click #new_job": () ->
		data = Session.get "onboarding_job_posting"
		if data
			Meteor.call "add_job_post", data
		else
			sAlert.error "missing job posting data"


