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

##########################################################
# Jobs
##########################################################

#########################################################
Template.jobs.onCreated () ->
	this.subscribe "my_organizations", []

##########################################################
Template.jobs.events
	"click #add_job": () ->
		Modal.show 'job_select_org'


#########################################################
# Select organization
#########################################################

#########################################################
Template.job_select_org.onCreated () ->
	self = this
	self.selected_org = new ReactiveVar(undefined)

	self.update_selected = (event) ->
		org = $('.user_select_class').val()
		self.selected_org.set org


#########################################################
Template.job_select_org.onRendered () ->
	$(".selectpicker").selectpicker()

#########################################################
Template.job_select_org.helpers
	org_selected: () ->
		inst = Template.instance()
		org = inst.selected_org.get()
		return org

	organizations: () ->
		return Organizations.find()

#########################################################
Template.job_select_org.events
	"show.bs.select .user_select_class": () ->
		inst = Template.instance()

		$(".selectpicker").off "changed.bs.select", inst.update_selected
		$(".selectpicker").on "changed.bs.select", inst.update_selected

	"click #add_job": () ->
		inst = Template.instance()
		organization_id = inst.selected_org.get()

		Meteor.call "add_job", organization_id,
			(err, res) ->
				if err
					sAlert.error("Add challenge error: " + err)
				if res
					query =
						job_id: res
						organization_id: organization_id
					url = build_url "challenge_design", query
					FlowRouter.go url


#########################################################
# Job preview
#########################################################

#########################################################
Template.job_preview.onCreated () ->
	self = this
	self.autorun ()->
		data = self.data
		id = data.organization_id
		Meteor.subscribe("organization_by_id", id)

#########################################################
Template.job_preview.helpers
	title: () ->
		inst = Template.instance()
		data = inst.data
		if data.title
			return data.title
		return "Click here to edit your job posting."

	get_role: () ->
		inst = Template.instance()
		data = inst.data

		map =
			marketing: "Marketing"
			design: "Design"
			sales: "Sales"
			other: "Other"
			ops: "Operations"
			dev: "Engineering"

		res = map[data.role]
		return res

	get_organization: () ->
		inst = Template.instance()
		data = inst.data

		id = data.organization_id
		org = Organizations.findOne id

		return org


#########################################################
# Job challenges preview
#########################################################

#########################################################
Template.job_challenges_preview.onCreated () ->
	self = this
	self.autorun ()->
		self.subscribe "challenges_by_ids", self.data.challenge_ids

#########################################################
Template.job_challenges_preview.helpers
	challenges: () ->
		inst = Template.instance()
		ids = inst.data.challenge_ids

		filter =
			_id:
				$in: ids

		return Challenges.find(filter)

#########################################################
# Job posting
#########################################################

#########################################################
Template.job_posting.onCreated () ->
	self = this
	self.autorun ()->
		job_id = FlowRouter.getQueryParam("job_id")
		organization_id = FlowRouter.getQueryParam("organization_id")

		self.subscribe "job_by_id", job_id
		self.subscribe "organization_by_id", organization_id
		self.subscribe "invitations_by_organization_id", organization_id


#########################################################
Template.job_posting.helpers
	job: () ->
		id = FlowRouter.getQueryParam("job_id")
		return Jobs.findOne(id)

	organization_id: () ->
		id = FlowRouter.getQueryParam("organization_id")
		return id

	job_persona: (data) ->
		job = persona_build(data)
		return job

	team_persona: () ->
		members = TeamMembers.find().fetch()
		team = persona_extract_team(members)

		if not team
			return team

		team = persona_normalize_component(team, 0, 40)
		team = persona_map team, persona_map_person_to_job

		return team

	team_requirement: (trait) ->
		members = TeamMembers.find().fetch()
		team = persona_extract_team(members)

		if not team
			return team

		team = persona_normalize_component(team, 0, 100)
		team = persona_map team, persona_map_person_to_job

		for t in team
			if t.label == trait
				return Math.round(t.value)

		return 0

	optimal_persona: (data) ->
		members = TeamMembers.find().fetch()
		team = persona_extract_team(members)
		if not team
			return undefined

		job = persona_build(data)
		res = persona_optimize_team(team, job)

		return res


#########################################################
Template.job_posting.events
	"click #new_job": () ->
		data = Session.get "onboarding_job_posting"
		if data
			Meteor.call "add_job_post", data
		else
			sAlert.error "missing job posting data"

	"click #add_challenge": () ->
		loc_job_id = FlowRouter.getQueryParam("job_id")
		Meteor.call "add_challenge", loc_job_id,
			(err, res) ->
				if err
					sAlert.error("Add challenge error: " + err)
				if res
					query =
						challenge_id: res
						job_id: loc_job_id
					url = build_url "challenge_design", query
					FlowRouter.go url

	"click #template_challenge": () ->
		loc_job_id = FlowRouter.getQueryParam("job_id")
		query =
			job_id: loc_job_id
		url = build_url "challenge_pool", query
		FlowRouter.go url

###############################################################################
# Trait vis
###############################################################################

###############################################################################
# locals
###############################################################################

###############################################################################
_marker_div = 2.5
_marker_width = 0.5
_balance_level = 0.75

###############################################################################
_percent_to_x = (percent, radius, x_origin) ->
	p = (percent / -100.0) * 2.0 - 1.0
	rad = Math.PI * 0.5 * p
	p_u = Math.sin(rad)
	x = p_u * radius

	return x + radius + x_origin

###############################################################################
_percent_to_y = (percent, radius, y_origin) ->
	p = (percent / -100.0) * 2.0 - 1.0
	rad = Math.PI * 0.5 * p
	p_u = Math.cos(rad)
	y = p_u * radius

	return  y + y_origin

###############################################################################
Template.trait_requirement.helpers
	sd_n1_low: () ->
		data = Template.instance().data
		z = (data.mean - data.sd * _balance_level) / 40.0 * 100.0
		return Math.round(z) - _marker_div

	sd_n1_high: () ->
		data = Template.instance().data
		z = (data.mean - data.sd * _balance_level) / 40.0 * 100.0
		return Math.round(z) + _marker_div

	sd_p1_low: () ->
		data = Template.instance().data
		z = (data.mean + data.sd * _balance_level) / 40.0 * 100.0
		return Math.round(z) - _marker_div

	sd_p1_high: () ->
		data = Template.instance().data
		z = (data.mean + data.sd * _balance_level) / 40.0 * 100.0
		return Math.round(z) + _marker_div

	mean_p_low: () ->
		data = Template.instance().data
		z = (data.mean) / 40.0 * 100.0
		return z - _marker_width

	mean_p_high: () ->
		data = Template.instance().data
		z = (data.mean) / 40.0 * 100.0
		return z + _marker_width

	mean_p: () ->
		data = Template.instance().data
		z = (data.mean) / 40.0 * 100.0
		return z

	score_p_low: () ->
		data = Template.instance().data
		z = (data.score) / 40.0 * 100.0
		return z - _marker_width

	score_p_high: () ->
		data = Template.instance().data
		z = (data.score) / 40.0 * 100.0
		return z + _marker_width

	score_p: () ->
		data = Template.instance().data
		z = (data.score) / 40.0 * 100.0
		return z + _marker_width

	get_arc: (percent_start, percent_end, radius, x_origin, y_origin) ->
		x_s = _percent_to_x(percent_start, radius, x_origin)
		y_s = _percent_to_y(percent_start, radius, y_origin)

		x_e = _percent_to_x(percent_end, radius, x_origin)
		y_e = _percent_to_y(percent_end, radius, y_origin)

		return "M#{x_s} #{y_s} A #{radius} #{radius}, 0, 0, 1, #{x_e} #{y_e}"

