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
_persona = [ { label: "Manager", value: 1 },
						 { label: "Organizer", value: 1 },
						 { label: "Mediator", value: 1 },
						 { label: "Builder", value: 1 },
						 { label: "Visionary", value: 1 } ]

#########################################################
_role_map =
	design:
		manager: 0
		organizer: 0
		mediator: 0
		builder: 0.2
		visionary: 0.5
	ops:
		manager: 0.2
		organizer: 0.5
		mediator: 0.2
		builder: 0.1
		visionary: 0
	dev:
		manager: 0
		organizer: 0.25
		mediator: 0.1
		builder: 0.5
		visionary: 0
	sales:
		manager: 0.2
		organizer: 0.2
		mediator: 0.4
		builder: 0
		visionary: 0.2
	marketing:
		manager: 0.1
		organizer: 0.2
		mediator: 0.5
		builder: 0
		visionary: 0.5
	other:
		manager: 0.2
		organizer: 0.2
		mediator: 0.2
		builder: 0.2
		visionary: 0.2

#########################################################
_build_persona = (data) ->
	if not data
		return

	role = data["role"] || "other"
	idea = data["idea"] || 0
	team = data["team"] || 0
	proc = data["process"] || 0
	stra = data["strategic"] || 0

	base = 0.1

	man = base
	org = base
	med = base
	bui = base
	vis = base

	if role
		man += _role_map[role]["manager"]
		org += _role_map[role]["organizer"]
		med += _role_map[role]["mediator"]
		bui += _role_map[role]["builder"]
		vis += _role_map[role]["visionary"]

	man += team + proc * 0.25 + stra
	org += team + proc
	med += team
	bui += 			+ proc
	vis += 			+ stra	+ idea

	sum = man + org + med + bui + vis

	persona = [ { label: "Manager", value: man/sum },
							{ label: "Organizer", value: org/sum },
							{ label: "Mediator", value: med/sum },
							{ label: "Builder", value: bui/sum },
							{ label: "Visionary", value: vis/sum } ]

	return persona


#########################################################
_check_session = () ->
	if not Session.get "user_occupation"
		return false

	if not Session.get "onboarding_job_posting"
		return false

	if not Session.get "onboarding_persona_data"
		return false

	return true


#########################################################
# Onboarding Intro
#########################################################

#########################################################
Template.onboarding_intro.onCreated ->
	self = this

	Session.set "user_occupation", "company"
	Session.set "onboarding_job_posting", {}
	Session.set "onboarding_persona_data", _persona

	self.autorun ()->
		self.subscribe "my_admissions"
		filter =
			collection_name: "jobs"
		admissions = Admissions.find(filter).fetch()
		self.subscribe "my_jobs", admissions

#########################################################
# Onboarding Intro
#########################################################

#########################################################
Template.onboarding_intro.helpers
	has_jobs: () ->
		if Jobs.find().count()>0
			FlowRouter.go "onboarding_finish"

#########################################################
# Onboarding Role
#########################################################

#########################################################
Template.onboarding_role.onCreated ->
	if not _check_session()
		FlowRouter.go "onboarding_intro"


#########################################################
# Onboarding Competency
#########################################################

#########################################################
Template.onboarding_competency.onCreated ->
	if not _check_session()
		FlowRouter.go "onboarding_intro"


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
				if Jobs.find().count() == 0
					if not _check_session()
						FlowRouter.go "onboarding_intro"


#########################################################
Template.onboarding_finish.onRendered ->
	Tracker.autorun () ->
		persona_data = _build_persona Session.get "onboarding_job_posting"
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
_ensure_company = () ->
	filter =
		collection_name: "companies"
	admissions = Admissions.find(filter).fetch()
	self.subscribe "my_companies", admissions,
		(err, res) ->
			if Companies.find().count() == 0
				Meteor.call "add_company", data,
					(err, res) ->
						if Jobs.find().count() == 0
							Meteor.call "add_job_post", data



#########################################################
Template.job_posting.onCreated () ->
	self = this
	data = Session.get "onboarding_job_posting"

	self.autorun ()->
		self.subscribe "my_admissions"

		org_filter =
			collection_name: "organization"
		org_admissions = Admissions.find(org_filter).fetch()

		job_filter =
			collection_name: "jobs"
		job_admissions = Admissions.find(job_filter).fetch()

		self.subscribe "my_organizations", org_admissions
		self.subscribe "my_jobs", job_admissions

		self.subscriptionsReady (err, res) ->
			sAlert.error err
			sAlert.success res
			if Organizations.find().count() == 0
				Meteor.call "onboard_organization", data


#########################################################
Template.job_posting.helpers
	jobs: () ->
		return Jobs.find()

	persona_data: (data) ->
		res = _build_persona(data)
		return res


#########################################################
Template.job_posting.events
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
Template.group_page.onCreated ()  ->
	self = this
	self.candidates = new ReactiveVar([])
	self.selected = new ReactiveVar([])

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
					self.candidates.set mails

	self.update_candidate = (event) ->

	self.update_selected = (event) ->
		val = $('.user_select_class').val()

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

	possible_users: () ->
		inst = Template.instance()
		users = inst.candidates.get()

		console.log "refresh", users.length
		$('.user_select_class').selectpicker('refresh')

		return users

	selected_users: () ->
		inst = Template.instance()
		return inst.selected.get()

	is_last: (mail) ->
		if mail != "__is__last__"
			return false

		#$('.user_select_class').selectpicker('refresh')
		return true


#########################################################
Template.group_page.events
	"show.bs.select .user_select_class": () ->
		inst = Template.instance()

		$(".user_select_class input").off "keydown", inst.find_user
		$(".user_select_class input").on "keydown", inst.find_user

		$(".user_select_class input").off "keyup", inst.update_candidate
		$(".user_select_class input").on "keyup", inst.update_candidate

		$(".user_select_class").off "click", inst.update_selected
		$(".user_select_class").on "click", inst.update_selected

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
		Meteor.call "invite_team_member", selected, "company",
			(err, res) ->
				sAlert.error err
				sAlert.success res


