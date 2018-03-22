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
#
# Onboarding Role
#
################################################################################

################################################################################
Template.onboarding_job_role.onCreated ->
	_check_session()


################################################################################
#
# Onboarding Competency
#
################################################################################

################################################################################
Template.onboarding_job_competency.onCreated ->
	_check_session()

################################################################################
#
# Onboarding Finish
#
################################################################################

################################################################################
Template.onboarding_job_registration.onCreated ->
	self = this
	self.autorun ()->
		_check_session()
		self.subscribe "my_organizations"


################################################################################
Template.onboarding_job_registration.onRendered ->
	Tracker.autorun () ->
		persona_data = persona_build Session.get "onboarding_job_posting"
		Session.set "onboarding_job_persona_data", persona_data


################################################################################
Template.onboarding_job_registration.helpers
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
Template.onboarding_job_registration.events
	"click #register":()->
		Modal.show 'onboarding_job_register'


################################################################################
#
# Onboarding register
#
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
#
# View to add Organization and user information
#
################################################################################

################################################################################
Template.onboarding_job_owner.onCreated ->
	self = this

	self.autorun ()->
		org_admissions = get_admissions(IGNORE, IGNORE, Organizations, IGNORE).fetch()

		organization_id = ""
		if org_admissions.length > 0
			organization_id = org_admissions[0].resource_id
			self.data.organization_id = organization_id

		self.subscribe "my_organizations", org_admissions

		if self.subscriptionsReady()
			if Organizations.find().count() == 0
				Meteor.call "onboard_organization",
					(err, res) ->
						if res
							sAlert.success("Organization created")
						if err
							sAlert.error(err)


################################################################################
Template.onboarding_job_owner.helpers
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


################################################################################
Template.onboarding_job_owner.events
	"click #describe_challenge": (event) ->
		org = Organizations.findOne()
		data = Session.get "onboarding_job_posting"

		Meteor.call "onboard_job", data, org._id,
			(err, res) ->
				if err
					sAlert.error(err)
					return

				query =
					job_id: res
					organization_id: org._id

				href = build_url "onboarding_describe_job", query, "onboarding"
				FlowRouter.go href


################################################################################
#
# Describe your job post
#
################################################################################

################################################################################
Template.onboarding_describe_job.onCreated () ->
	job_id = FlowRouter.getQueryParam("job_id")

	self = this
	self.matching = new ReactiveVar(false)
	self.concepts = new ReactiveVar([])

	self.parameter =
		page: 0
		size: 100
		item_id: job_id

	self.autorun () ->
		self.subscribe("job_by_id", job_id)
		self.subscribe("my_matches", self.parameter)


################################################################################
Template.onboarding_describe_job.helpers
	parameter: () ->
		return Template.instance().parameter

	get_url: () ->
		param =
			job_id: FlowRouter.getQueryParam("job_id")
			organization_id: FlowRouter.getQueryParam("organization_id")

		url = build_url "onboarding_select_challenges", param, "onboarding"
		return url

	tasks: () ->
		return NLPTasks.find().count()>0

	#############################################################################
  # job description
	#############################################################################
	job:()->
		job_id = FlowRouter.getQueryParam("job_id")
		job = Jobs.findOne(job_id)
		return job

	get_job_id:()->
		job_id = FlowRouter.getQueryParam("job_id")
		return job_id

	#############################################################################
  # matches
	#############################################################################
	match_disabled: () ->
		if Template.instance().matching.get()
			return "disabled"
		return ""

	is_matching: () ->
		return Template.instance().matching.get()

	n_matches: () ->
		return Matches.find().count()

	#############################################################################
  # concepts
	#############################################################################
	has_concepts: () ->
		return Matches.find().count()>0

	concepts: () ->
		res = new Set()
		for m in Matches.find().fetch()
			for c in m.c
				res.add(c)

		job_id = FlowRouter.getQueryParam("job_id")
		job = Jobs.findOne(job_id)
		if job.concepts
			for c in job.concepts
				res.add(c)

		inst = Template.instance()
		concepts = Array.from(res)
		inst.concepts.set(concepts)

		return concepts

	n_concepts: () ->
		inst = Template.instance()
		concepts = inst.concepts.get()

		return concepts.length

	drop_function: () ->
		job_id = FlowRouter.getQueryParam("job_id")
		o =
			func: (x) ->
				concept = x.data.label
				collection_name = get_collection_name(Jobs)
				Meteor.call "remove_concept_from_matches", concept, collection_name, job_id

		return o


################################################################################
Template.onboarding_describe_job.events
	"click #match":(event)->
		if event.target.attributes.disabled
			return

		inst = Template.instance()
		inst.matching.set true

		collection_name = "jobs"
		item_id = FlowRouter.getQueryParam("job_id")
		field = "content"

		in_collection = "challenges"
		in_field = "description"

		Meteor.call "match_document", collection_name, item_id, field, in_collection, in_field,
			(err, res)->
				inst.matching.set false
				if err
					sAlert.error(err)
					return
				inst.subscribe("active_nlp_task", res.match_id)

	"change #new_tag":(event)->
		inst = Template.instance()
		inst.matching.set true

		concept = event.target.value
		collection_name = "jobs"
		item_id = FlowRouter.getQueryParam("job_id")

		Meteor.call "add_concept", concept, collection_name, item_id,
			(err, res)->
				inst.matching.set false
				if err
					sAlert.error(err)
					return
				inst.subscribe("active_nlp_task", res.match_id)


################################################################################
#
# Select the challenges for your jop posting
#
################################################################################

################################################################################
Template.onboarding_select_challenges.helpers
	get_url: () ->
		param =
			job_id: FlowRouter.getQueryParam("job_id")
			organization_id: FlowRouter.getQueryParam("organization_id")

		url = build_url "onboarding_team_members", param, "onboarding"
		return url

################################################################################
#
# Select the challenges for your jop posting
#
################################################################################

################################################################################
Template.onboarding_team_members.helpers
	get_url: () ->
		param =
			job_id: FlowRouter.getQueryParam("job_id")
			organization_id: FlowRouter.getQueryParam("organization_id")

		url = build_url "onboarding_job_overview", param, "onboarding"
		return url


################################################################################
#
# Select the challenges for your jop posting
#
################################################################################

################################################################################
Template.onboarding_job_overview.helpers
	get_url: () ->
		param =
			job_id: FlowRouter.getQueryParam("job_id")
			organization_id: FlowRouter.getQueryParam("organization_id")

		url = build_url "job_posting", param, "app"
		return url


