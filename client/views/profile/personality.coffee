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
#
# Team member personality survey
#
###############################################################################

###############################################################################
Template.personality.onCreated () ->
	this.answers = new ReactiveDict()
	this.persona_data = new ReactiveVar(persona_big_5)


###############################################################################
Template.personality.onRendered () ->
	# TODO: make this reactive on the level of survey.
	self = this
	self.autorun () ->
		user_id = Meteor.userId()
		profile = Profiles.findOne({user_id:user_id})

		if profile
			answers = profile.big_five
			if answers
				self.answers.set answers


###############################################################################
Template.personality.helpers
	answers: () ->
		instance = Template.instance()
		answers = instance.answers
		return answers

	questions: () ->
		#return big_five_40
		return big_five_15

	persona_data: () ->
		instance = Template.instance()
		answers = instance.answers
		persona = calculate_persona answers.keys
		instance.persona_data.set persona
		return instance.persona_data.get()

	score:(score_name)->
		instance = Template.instance()
		answers = instance.answers
		return calculate_trait score_name, answers.keys

	mean:(score_name)->
		return Math.round((big_5_mean[score_name].m * 10) - 10)

	sd:(score_name)->
		return big_5_mean[score_name].sd * 10

	percentile:(score_name)->
		instance = Template.instance()
		answers = instance.answers

		m = (big_5_mean[score_name].m - 1.0) / 4
		sd = big_5_mean[score_name].sd / 4
		s = calculate_trait(score_name, answers.keys) / 40

		per = percentile(s, m, sd)

		return per


	level:(score_name)->
		instance = Template.instance()
		answers = instance.answers

		m = (big_5_mean[score_name].m - 1.0) / 4
		sd = big_5_mean[score_name].sd / 4
		s = calculate_trait(score_name, answers.keys) / 40

		d = s - m
		z = d / sd

		if z > _balance_level
			return "high"

		if z < -_balance_level
			return "low"

		return "balanced"


###############################################################################
# Trait vis
###############################################################################

###############################################################################
Template.trait_comparison.helpers
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

