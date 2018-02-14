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
	self = this
	self.autorun () ->
		user_id = Meteor.userId()
		console.log user_id
		profile = Profiles.findOne({user_id:user_id})
		console.log profile

		if profile
			answers = profile.big_five
			if answers
				self.answers.set answers


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
		instance = Template.instance()
		answers = instance.answers

		m = (big_5_mean[score_name].m - 1.0) / 4
		sd = big_5_mean[score_name].sd / 4
		s = calculate_trait_40(score_name, answers.keys) / 40

		per = percentile(s, m, sd)

		return per


	level:(score_name)->
		instance = Template.instance()
		answers = instance.answers

		m = (big_5_mean[score_name].m - 1.0) / 4
		sd = big_5_mean[score_name].sd / 4
		s = calculate_trait_40(score_name, answers.keys) / 40

		d = s - m
		z = d / sd

		if z > 0.5
			return "high"

		if z < -0.5
			return "low"

		return "balanced"

