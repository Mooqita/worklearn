#########################################################
# locals
#########################################################

##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

#########################################################
#
# Team member personality survey
#
#########################################################

#########################################################
Template.personality.onCreated () ->
	this.answers = new ReactiveDict()
	this.persona_data = new ReactiveVar(persona_big_5)


#########################################################
Template.personality.onRendered () ->
	# TODO: make this reactive on the level of survey.

	collection_name = "profiles"
	item_id = get_profile_id()
	field = "big_five"

	answers = get_field_value this.data, field, item_id, collection_name
	if answers
		this.answers.set answers


#########################################################
Template.personality.helpers
	answers: () ->
		instance = Template.instance()
		answers = instance.answers
		return answers

	questions: () ->
		return big_five_40

	persona_data: () ->
		instance = Template.instance()
		answers = instance.answers
		persona = calculate_persona_40 answers.keys
		instance.persona_data.set persona
		return instance.persona_data.get()

	score:(score_name)->
		instance = Template.instance()
		answers = instance.answers
		return calculate_trait_40 score_name, answers.keys

	mean:(score_name)->
		return Math.round((big_5_mean[score_name].m * 10) - 10)

	sd:(score_name)->
		return big_5_mean[score_name].sd * 10

	percentile:(score_name)->
		Z_MAX = 6

		instance = Template.instance()
		answers = instance.answers

		m = (big_5_mean[score_name].m * 10) - 10
		sd = (big_5_mean[score_name].sd * 10)
		s = calculate_trait_40 score_name, answers.keys
		d = s - m
		z = d / sd

		y = 0
		x = 0
		w = 0

		if (z == 0.0)
			x = 0.0
		else
			y = 0.5 * Math.abs(z)

			if (y > (Z_MAX * 0.5))
				x = 1.0
			else if (y < 1.0)
				w = y * y
				x = ((((((((0.000124818987 * w - 0.001075204047) * w + 0.005198775019) * w - 0.019198292004) * w + 0.059054035642) * w - 0.151968751364) * w + 0.319152932694) * w - 0.531923007300) * w + 0.797884560593) * y * 2.0
			else
				y -= 2.0
				x = (((((((((((((-0.000045255659 * y + 0.000152529290) * y - 0.000019538132) * y - 0.000676904986) * y + 0.001390604284) * y - 0.000794620820) * y - 0.002034254874) * y + 0.006549791214) * y - 0.010557625006) * y + 0.011630447319) * y - 0.009279453341) * y	+ 0.005353579108) * y - 0.002141268741) * y + 0.000535310849) * y + 0.999936657524

		lp = if z > 0.0 then ((x + 1.0) * 0.5) else ((1.0 - x) * 0.5)
		return (lp * 100).toFixed(0)


	level:(score_name)->
		instance = Template.instance()
		answers = instance.answers
		score = calculate_trait_40 score_name, answers.keys

		if score > 22
			return "high"

		if score < 13
			return "low"

		return "balanced"

