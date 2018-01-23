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
_questions = ["is the life of the party",
				"feels little concern for others",
				"is always prepared",
				"gets stressed out easily",
				"has a rich vocabulary",
				"does not talk a lot",
				"is interested in people",
				"leaves my belongings around",
				"is relaxed most of the time",
				"has difficulty understanding abstract ideas",
				"feels comfortable around people",
				"insults people",
				"pays attention to details",
				"worries about things",
				"has a vivid imagination",
				"keeps in the background",
				"sympathizes with others' feelings",
				"makes a mess of things",
				"seldom feel blue",
				"is not interested in abstract ideas",
				"starts conversations",
				"is not interested in other people's problems",
				"gets chores done right away",
				"is easily disturbed",
				"has excellent ideas",
				"has little to say",
				"has a soft heart",
				"often forgets to put things back in their proper place",
				"gets upset easily",
				"does not have a good imagination",
				"talks to a lot of different people at parties",
				"is not really interested in others",
				"likes order",
				"changes their mood a lot",
				"is quick to understand things",
				"doesn't like to draw attention to myself",
				"takes time out for others",
				"shrikes their duties",
				"has frequent mood swings",
				"uses difficult words",
				"does't mind being the center of attention",
				"feels others' emotions",
				"follows a schedule",
				"gets irritated easily",
				"spends time reflecting on things",
				"is quiet around strangers",
				"makes people feel at ease",
				"is exacting in their work",
				"often feels blue",
				"is full of ideas"]

#########################################################
#
# Team member personality survey
#
#########################################################

#########################################################
_calculate_trait = (trait, answers) ->
	v = (i) ->
		q = _questions[i-1]
		n = answers.get q

		return Number(n)

	switch trait
		when "Extroversion" then return 20 + v(1) - v(6)  + v(11) - v(16) + v(21) - v(26) + v(31) - v(36) + v(41) - v(46)
		when "Agreeableness" then return 14 - v(2) + v(7)  - v(12) + v(17) - v(22) + v(27) - v(32) + v(37) + v(42) + v(47)
		when "Conscientiousness" then return 14 + v(3) - v(8)  + v(13) - v(18) + v(23) - v(28) + v(33) - v(38) + v(43) + v(48)
		when "Stability" then return 2  + v(4) - v(9)  + v(14) - v(19) + v(24) + v(29) + v(34) + v(39) + v(44) + v(49)
		when "Openness" then return 8  + v(5) - v(10) + v(15) - v(20) + v(25) - v(30) + v(35) + v(40) + v(45) + v(50)


#########################################################
Template.team_member.onCreated () ->
	this.answers = new ReactiveDict()
	this.persona_data = new ReactiveVar(_personality)


#########################################################
Template.team_member.helpers
	answers: () ->
		instance = Template.instance()
		answers = instance.answers
		return answers

	questions: () ->
		return _questions

	persona_data: () ->
		instance = Template.instance()
		answers = instance.answers

		E = _calculate_trait "Extroversion", answers
		A = _calculate_trait "Agreeableness", answers
		C = _calculate_trait "Conscientiousness", answers
		S = _calculate_trait "Stability", answers
		O = _calculate_trait "Openness", answers

		persona = [ { label: "Stability", value: S },
						 		{ label: "Openness", value: O },
						 		{ label: "Agreeableness", value: A },
						 		{ label: "Extroversion", value: E },
						 		{ label: "Conscientiousness", value: C } ]

		instance.persona_data.set persona
		return instance.persona_data

	score:(score_name)->
		instance = Template.instance()
		answers = instance.answers
		return _calculate_trait score_name, answers

	mean:(score_name)->
		instance = Template.instance()
		answers = instance.answers
		return _calculate_trait score_name, answers

	percentile:(score_name)->
		instance = Template.instance()
		answers = instance.answers
		return _calculate_trait score_name, answers

	level:(score_name)->
		instance = Template.instance()
		answers = instance.answers
		score = _calculate_trait score_name, answers

		if score>22
			return "high"

		if score<13
			return "low"

		return "balanced"

#########################################################
#
# Quick personality survey
#
#########################################################

#########################################################
Template.quick_survey.helpers
	percentage: () ->
		instance = Template.instance()
		questions = instance.data.questions
		answers = instance.data.answers
		answered = Object.keys answers.keys
		open = _.difference(questions, answered)

		answers.get open[0]

		count = Object.keys(answers.keys).length
		total = questions.length
		perc = count / total * 95

		return 5 + perc

	count: () ->
		instance = Template.instance()
		questions = instance.data.questions
		answers = instance.data.answers
		answered = Object.keys answers.keys
		open = _.difference(questions, answered)

		answers.get open[0]

		count = Object.keys(answers.keys).length
		return count

	total: () ->
		instance = Template.instance()
		questions = instance.data.questions
		total = questions.length
		return total

	answers: () ->
		instance = Template.instance()
		return instance.data.answers

	current_question: () ->
		instance = Template.instance()
		questions = instance.data.questions
		answers = instance.data.answers
		answered = Object.keys answers.keys
		open = _.difference(questions, answered)

		if open.length ==0
			return false

		answers.get open[0]
		return open[0]


#########################################################
#
# Survey Item
#
#########################################################

#########################################################
_handle_selection = (instance, response) ->
	a_count = instance.answer_count
	data = instance.data
	data.answers.set data.question, response
	a_count.set a_count.get() + 1


#########################################################
Template.quick_survey_element.onCreated ()->
	this.answer_count = new ReactiveVar(0)


#########################################################
Template.quick_survey_element.onRendered ()->
	instance = Template.instance()

	$(document).on "keyup", (e) ->
		response = 0

		switch e.keyCode
			when 49 then response = 1
			when 50 then response = 2
			when 51 then response = 3
			when 52 then response = 4
			when 53 then response = 5

		_handle_selection instance, response


#########################################################
Template.quick_survey_element.onDestroyed () ->
	$(document).off("keyup")


#########################################################
Template.quick_survey_element.helpers
	redraw: () ->
		inst = Template.instance()
		q = inst.data.question

		f = () ->
			$(".element-container").addClass("animated").css("opacity", "1.0")

		Meteor.setTimeout(f, 100)
		return ""

	selected: () ->
		instance = Template.instance()
		data = instance.data
		dic = data.dict
		if not dic
			return

		str = dic.get data.key
		res = false
		res = (str == data.value)

		return res


#########################################################
Template.quick_survey_element.events
	"click .select-response": (event) ->
		$(".element-container").removeClass("animated").css("opacity", "0.0")

		response = event.target.id
		instance = Template.instance()

		_handle_selection instance, response


