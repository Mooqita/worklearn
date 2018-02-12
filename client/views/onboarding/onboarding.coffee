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


#########################################################
# Group setup
#########################################################

#########################################################
_refresh = (mails)->
	$('#user_select').empty()

	for mail in mails
		console.log mail
		html = '<option data-tokens="' + mail + '">' + mail + '</option>'
		$('#user_select').append html

	$('.user_select_class').selectpicker 'refresh'


#########################################################
Template.group_page.onCreated ()  ->
	self = this
	self.candidates = new ReactiveVar([])
	self.selected = new ReactiveVar([])

	self.autorun () ->
		o_id = self.data.organization_id
		self.subscribe "team_members_by_organization_id", o_id
		self.subscribe "invitations_by_organization_id", o_id

	self.find_user = (event) ->
		event = event || window.event
		switch event.keyCode
			when 38 then return
			when 40 then return
			when 37 then return
			when 39 then return

		value = event.target.value
		Meteor.call "find_user", value,
			(err, res) ->
				if res
					mails = (a.emails[0].address for a,index in res)
					mails.push value
					_refresh(mails)

	self.update_selected = (event) ->
		mails = $('.user_select_class').val()

		for val in mails
			if not check_mail val
				return

			selected = new Set(self.selected.get())
			selected.add val

			new_selected = Array.from(selected)
			self.selected.set new_selected


#########################################################
Template.group_page.onRendered () ->
	$(".selectpicker").selectpicker()


#########################################################
Template.group_page.helpers
	has_profile: () ->
		profile = undefined
		user_id = Meteor.userId()

		if user_id
			profile = get_profile(user_id)

		return profile

	selected_users: () ->
		inst = Template.instance()
		return inst.selected.get()

	invitations: () ->
		return Invitations.find()

	invitation_url: (invitation) ->
		param =
			organization_id: invitation.organization_id
			invitation_id: invitation._id

		return build_url "invitation", param

	members: () ->
		return TeamMembers.find()

	get_given_name: (profile) ->
		get_profile_name profile

	default_persona: () ->
		return persona_job

	persona_data: (profile) ->
		if not profile.big_five
			return undefined

		persona_5 = calculate_persona_40 profile.big_five
		persona_job = persona_map persona_5, persona_map_person_to_job

		return persona_job


#########################################################
Template.group_page.events
	"show.bs.select .user_select_class": () ->
		inst = Template.instance()

		$(".user_select_class input").off "keyup", inst.find_user
		$(".user_select_class input").on "keyup", inst.find_user

		$(".selectpicker").off "changed.bs.select", inst.update_selected
		$(".selectpicker").on "changed.bs.select", inst.update_selected

	"click .auto-complete-list-item": (event) ->
		inst = Template.instance()
		val = event.target.id

		selected = new Set(inst.selected.get())
		selected.delete val

		new_selected = Array.from(selected)
		inst.selected.set new_selected

	"click #invite": () ->
		inst = Template.instance()
		selected = inst.selected.get()
		org = Organizations.findOne()

		Meteor.call "invite_team_member", org._id, selected,
			(err, res) ->
				sAlert.error err
				sAlert.success res


