################################################################################
# Job Description
################################################################################

################################################################################
# local variables and methods
################################################################################

################################################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter

################################################################################
Template.job_persona.onCreated ->
	self =  this
	self.autorun () ->
		job_id = FlowRouter.getQueryParam("job_id")
		self.subscribe("job_by_id", job_id)

		organization_id = FlowRouter.getQueryParam("organization_id")
		self.subscribe("team_members_by_organization_id", organization_id)


################################################################################
Template.job_persona.helpers
	get_job: ()->
		job_id = FlowRouter.getQueryParam("job_id")
		job = Jobs.findOne(job_id)
		return job

	persona_available: () ->
		#TODO make sure that this returns true when there are team members
		profile = Profiles.findOne()

		if not profile
			return false

		if not profile.big_five
			return false

		return true

	optimal_persona: (data) ->
		members = TeamMembers.find().fetch()
		team = persona_extract_team(members)
		if not team
			return undefined

		job = persona_build(data)
		if not job
			return undefined

		res = persona_optimize_team(team, job)
		return res

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

