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

_5_persona = [ { label: "Stability", value: 1 },
							{ label: "Openness", value: 1 },
							{ label: "Agreeableness", value: 1 },
							{ label: "Extroversion", value: 1 },
							{ label: "Conscientiousness", value: 1 } ]

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
_map_job_to_person =
	Organizer: "Conscientiousness"
	Visionary: "Openness"
	Mediator: "Agreeableness"
	Manager: "Extroversion"
	Builder: "Stability"

#########################################################
_map_person_to_job =
	Conscientiousness: "Organizer"
	Agreeableness: "Mediator"
	Extroversion: "Manager"
	Stability: "Builder"
	Openness: "Visionary"

#########################################################
_intermediate_to_vis = (inter)->
	res = []
	for t, v of inter
		r =
			label: t
			value: v
		res.push r

	return res


#########################################################
_map = (a, map) ->
	inter = {}

	if not a
		return a

	if not (a.length > 0)
		return a

	for t in a
		label = t.label
		if map
			label = map[label]
		inter[label] = t.value

	return _intermediate_to_vis inter


#########################################################
_normalize = (a, w=undefined) ->
	if not w
		w = 0.0

		for t in a
			w += t.value

	for t in a
		t.value = t.value / w

	return a


#########################################################
_add = (a, b) ->
	inter = {}

	for t in a
		inter[t.label] = t.value

	for t in b
		inter[t.label] += t.value

	return _intermediate_to_vis inter


#########################################################
_add_v = (a, v) ->
	inter = {}

	for t in a
		inter[t.label] = t.value + v

	return _intermediate_to_vis inter


#########################################################
_sub = (a, b) ->
	inter = {}

	for t in a
		inter[t.label] = t.value

	for t in b
		inter[t.label] -= t.value

	return _intermediate_to_vis inter


#########################################################
_mul = (a, b) ->
	inter = {}

	for t in a
		inter[t.label] = t.value

	for t in b
		inter[t.label] *= t.value

	return _intermediate_to_vis inter


#########################################################
_mul_v = (a, v) ->
	inter = {}

	for t in a
		inter[t.label] = t.value * v

	return _intermediate_to_vis inter


#########################################################
_div = (a, b) ->
	inter = {}

	for t in a
		inter[t.label] = t.value

	for t in b
		inter[t.label] /= t.value

	return _intermediate_to_vis inter


#########################################################
_div_v = (a, v) ->
	inter = {}

	for t in a
		inter[t.label] = t.value / v

	return _intermediate_to_vis inter


#########################################################
_extract_requirements = (team) ->
	n = team.length

	if n == 0
		return undefined

	avg =
		Conscientiousness: 0
		Agreeableness: 0
		Extroversion: 0
		Stability: 0
		Openness: 0

	n = 0
	for member in team
		if not member.big_five
			continue

		b5 = calculate_persona_40 member.big_five
		n += 1

		for t in b5
			inv = t.value
			avg[t.label] = avg[t.label] + inv

	if n == 0
		return undefined

	for l in avg
		avg[l] /= n

	return _intermediate_to_vis avg


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

	persona = [ { label: "Manager", value: man / sum },
							{ label: "Organizer", value: org / sum },
							{ label: "Mediator", value: med / sum },
							{ label: "Builder", value: bui / sum },
							{ label: "Visionary", value: vis / sum } ]

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
Template.job_posting.onCreated () ->
	self = this
	data = Session.get "onboarding_job_posting"

	self.autorun ()->
		self.subscribe "my_admissions"

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

		self.subscribe "send_invitations", invite_admissions
		self.subscribe "my_organizations", org_admissions
		self.subscribe "team_members", organization_id
		self.subscribe "my_jobs", job_admissions

		if self.subscriptionsReady()
			if Organizations.find().count() == 0
				Meteor.call "onboard_organization", data


#########################################################
Template.job_posting.helpers
	jobs: () ->
		return Jobs.find()

	job_persona: (data) ->
		job = _build_persona(data)
		return job

	team_persona: () ->
		members = TeamMembers.find().fetch()
		team = _extract_requirements(members)
		team = _map team, _map_person_to_job
		return team

	optimal_persona: (data) ->
		max_change = 0.1

		members = TeamMembers.find().fetch()
		team = _extract_requirements(members)
		if not team
			return undefined

		team = _normalize(team)
		team = _map team, _map_person_to_job

		job = _build_persona(data)
		job = _normalize(job)

		j_sq = _mul(job, job)

		j_min = _mul_v(j_sq, max_change)
		j_min = _sub(job, j_min)

		j_max = _mul_v(j_sq, -1)
		j_max = _add_v(j_max, 1)
		j_max = _mul_v(j_max, max_change)
		j_max = _add(job, j_max)

		dif = _sub(team, job)
		dif = _add_v(dif, 1)
		dif = _div_v(dif, 2)

		res = _sub(j_max, j_min)
		res = _mul(dif, res)
		res = _add(res, j_min)

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
		return _persona

	persona_data: (profile) ->
		if not profile.big_five
			return undefined

		return calculate_persona_40 profile.big_five


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


