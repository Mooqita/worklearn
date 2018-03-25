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
	if not Session.get "onboarding_job_description"
		Session.set "onboarding_job_description", ""

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
	self.concepts = new ReactiveVar([])
	self.data.session = "onboarding_job_description"

	_check_session()

	self.autorun ()->
		text = get_value_from_context(self)
		item_id = fast_hash(text)

		parameter =
			page: 0
			size: 100
			item_id: item_id

		self.subscribe("my_matches", parameter)

		org_admissions = get_admissions(IGNORE, IGNORE, Organizations, IGNORE).fetch()
		self.subscribe "my_organizations", org_admissions

################################################################################
Template.onboarding_job_registration.onRendered ->
	Tracker.autorun () ->
		persona_data = persona_build Session.get "onboarding_job_posting"
		Session.set "onboarding_job_persona_data", persona_data


################################################################################
Template.onboarding_job_registration.helpers
	has_concepts: () ->
		return Matches.find().count()>0

	concepts: () ->
		context = Template.instance()
		concepts = concepts_from_context(context)

		context.concepts.set(concepts)
		return concepts

	n_concepts: () ->
		context = Template.instance()
		concepts = context.concepts.get()

		return concepts.length

	n_challenges: () ->
		filter =
			cb: "challenges"

		return Matches.find(filter).count()

	n_profiles: () ->
		filter =
			cb: "profiles"

		return Matches.find(filter).count()

	user_profile: () ->
		profile = undefined
		user_id = Meteor.userId()

		if user_id
			profile = Profiles.findOne {user_id: user_id}

		return profile

	persona_data: () ->
		return Session.get "onboarding_job_persona_data"


################################################################################
Template.onboarding_job_registration.events
	"click #register": () ->
		Modal.show 'onboarding_job_register'

	"click #job_overview": () ->
		org = Organizations.findOne()
		data = Session.get "onboarding_job_posting"
		desc = Session.get "onboarding_job_description"
		data.description = desc

		make_job = (org_id) ->
			Meteor.call "onboard_job", data, org_id,
				(err, res) ->
					if err
						sAlert.error(err)
						return

					query =
						job_id: res
						organization_id: org._id

					href = build_url "job_posting", query, "app"
					FlowRouter.go href

		if org
			make_job(data, org._id)
			return

		Meteor.call "onboard_organization",
			(err, res) ->
				if res
					sAlert.success("Organization created")
					make_job(data, res)
				if err
					sAlert.error(err)


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
	_check_session()


################################################################################
Template.onboarding_describe_job.helpers
	text: () ->
		return Session.get("text")

	has_text: () ->
		text = Session.get("text")
		return text.length>10


################################################################################
Template.onboarding_describe_job.events


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


