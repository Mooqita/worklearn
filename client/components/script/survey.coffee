#################################################################################
#
# Quick personality survey
#
# TODO: make this reactive!!! Well would be nice it is not yet critical.
#
###############################################################################

###############################################################################
Template.quick_survey.helpers
	finished: () ->
		instance = Template.instance()
		questions = instance.data.questions
		answers = instance.data.answers
		answered = Object.keys answers.keys
		open = _.difference(questions, answered)

		answers.get open[0]

		count = Object.keys(answers.keys).length
		total = questions.length

		return count == total

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
		data = instance.data
		questions = data.questions
		answers = data.answers
		answered = Object.keys answers.keys
		open = _.difference(questions, answered)

		answers.get open[0]
		return open[0]


###############################################################################
#
# Survey Item
#
###############################################################################

###############################################################################
_handle_selection = (instance, response) ->
	a_count = instance.answer_count
	data = instance.data
	answers = data.answers

	max = data.max_answer_count
	count = Object.keys(data.answers.keys).length

	if count >= max
		return

	console.log max, count

	answers.set data.question, parseInt response
	a_count.set a_count.get() + 1

	value = {}
	for k, v of answers.keys
		val = answers.get k
		value[k] = val

	if not data.collection_name
		return

	collection_name = data.collection_name
	item_id = data.item_id
	field = data.field

	set_field collection_name, item_id, field, value, false


###############################################################################
Template.quick_survey_element.onCreated ()->
	this.answer_count = new ReactiveVar(0)


###############################################################################
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

		if response != 0
			_handle_selection instance, response


###############################################################################
Template.quick_survey_element.onDestroyed () ->
	$(document).off("keyup")


###############################################################################
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


###############################################################################
Template.quick_survey_element.events
	"click .select-response": (event) ->
		$(".element-container").removeClass("animated").css("opacity", "0.0")

		response = event.target.id
		instance = Template.instance()

		_handle_selection instance, response


