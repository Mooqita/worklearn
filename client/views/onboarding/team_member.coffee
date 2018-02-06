#########################################################
# locals
#########################################################

##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

#########################################################
_personality = [ { label: "Stability", value: 1 },
								 { label: "Openness", value: 1 },
								 { label: "Agreeableness", value: 1 },
								 { label: "Extroversion", value: 1 },
								 { label: "Conscientiousness", value: 1 } ]

#########################################################
#
# Team member personality survey
#
#########################################################

#########################################################
Template.team_member.onCreated () ->
	this.answers = new ReactiveDict("answers")
	this.persona_data = new ReactiveVar(_personality)


#########################################################
Template.team_member.onRendered () ->
	# TODO: make this reactive on the level of survey.

	collection_name = "profiles"
	item_id = get_profile_id()
	field = "big_five"

	answers = get_field_value this.data, field, item_id, collection_name
	if answers
		this.answers.set answers


#########################################################
Template.team_member.helpers
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
		instance = Template.instance()
		answers = instance.answers
		return calculate_trait_40 score_name, answers.keys

	percentile:(score_name)->
		instance = Template.instance()
		answers = instance.answers
		return calculate_trait_40 score_name, answers.keys

	level:(score_name)->
		instance = Template.instance()
		answers = instance.answers
		score = calculate_trait_40 score_name, answers.keys

		if score > 22
			return "high"

		if score < 13
			return "low"

		return "balanced"
