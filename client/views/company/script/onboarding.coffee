#########################################################
#
# Hover Cards
#
#########################################################

#########################################################
Template.hover_card.helpers
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
Template.hover_card.events
	"click .onboarding-select": () ->
		instance = Template.instance()
		data = instance.data
		data.dict.set data.key, data.value


#########################################################
#
# Team member personality survey
#
#########################################################

#########################################################
_persona = [ { label: "Manager", value: 1 },
						 { label: "Organizer", value: 1 },
						 { label: "Mediator", value: 1 },
						 { label: "Builder", value: 1 },
						 { label: "Visionary", value: 1 } ]

#########################################################
_personality = [ { label: "Stability", value: 1 },
								 { label: "Openness", value: 1 },
								 { label: "Agreeableness", value: 1 },
								 { label: "Extroversion", value: 1 },
								 { label: "Conscientiousness", value: 1 } ]

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

	persona_data: () ->
		instance = Template.instance()
		persona = instance.persona_data
		return persona


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


#########################################################
#
# Onboarding data collection
#
#########################################################

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
	role = data.get "role"

	idea = data.get "idea"
	team = data.get "team"
	proc = data.get "process"
	stra = data.get "strategic"

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
Template.onboarding.onCreated ->
	dict = new ReactiveDict()

	dict.set "idea", undefined
	dict.set "idea", 0
	dict.set "team", 0
	dict.set "process", 0
	dict.set "strategic", 0

	this.candidate_info = dict
	this.persona_data = new ReactiveVar("")


#########################################################
Template.onboarding.helpers
	candidate_info: () ->
		instance = Template.instance()
		return instance.candidate_info


	persona_data: () ->
		instance = Template.instance()
		persona_data = _build_persona instance.candidate_info
		instance.persona_data.set persona_data

		return instance.persona_data

	ready: () ->
		instance = Template.instance()
		return instance.candidate_info.get "role"


#########################################################
Template.onboarding.events
	"click .toggle-button": () ->
		instance = Template.instance()
		dict = instance.candidate_info

		dict.set "idea", if instance.find("#idea_id").checked then 1 else 0
		dict.set "team", if instance.find("#team_id").checked then 1 else 0
		dict.set "process", if instance.find("#process_id").checked then 1 else 0
		dict.set "strategic", if instance.find("#strategic_id").checked then 1 else 0


#########################################################
#
# Persona
#
#########################################################

#########################################################
_svg = null

#########################################################
_draw_persona = (data, id, width = 350, height = 200) ->
	if not data
		console.log "no data"
		return

	if not id
		console.log "no id"
		return

	radius = Math.min(width, height) / 2

	if not _svg
		console.log d3.select("#" + id)

		_svg = d3.select("#" + id)
			.append("svg")
			.attr("viewBox", "0 0 "+width+" "+height+"")
			.append("g")

		_svg.append("g")
			.attr("class", "slices")
		_svg.append("g")
			.attr("class", "labels")
		_svg.append("g")
			.attr("class", "lines")

		_svg.attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")

	arc = d3.svg.arc()
		.outerRadius(radius * 0.8)
		.innerRadius(radius * 0.4)

	outerArc = d3.svg.arc()
		.innerRadius(radius * 0.9)
		.outerRadius(radius * 0.9)

	pie = d3.layout.pie()
		.value (d) ->
			return d.value

	color = d3.scale.ordinal()
		.domain(["Manager", "Builder", "Mediator", "Organizer", "Visionary"])
		.range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56"])

	key = (d) -> return d.data.label

	#############################################################################
	# Donut Slices
	#############################################################################
	slice = _svg.select(".slices")
		.selectAll("path.slice")
		.data(pie(data), key)

	slice.enter()
		.insert("path")
		.style("fill", (d) -> return color(d.data.label) )
		.attr("class", "slice")

	slice
		.transition().duration(1000)
		.attrTween("d", (d) ->
			this._current = this._current || d
			interpolate = d3.interpolate(this._current, d)
			this._current = interpolate(0)
			return (t) ->
				return arc(interpolate(t)))

	slice.exit()
		.remove()

	#############################################################################
	# Text Labels
	#############################################################################

	#############################################################################
	midAngle = (d) ->
		return d.startAngle + (d.endAngle - d.startAngle)/2

	#############################################################################
	text = _svg.select(".labels")
		.selectAll("text")
		.data(pie(data), key)

	text.enter()
		.append("text")
		.attr("dy", ".35em")
		.text (d) ->
			return d.data.label

	text.transition().duration(1000)
		.attrTween("transform", (d) ->
			this._current = this._current || d
			interpolate = d3.interpolate(this._current, d)
			this._current = interpolate(0)
			return (t) ->
				d2 = interpolate(t)
				pos = outerArc.centroid(d2)
				pos[0] = radius * if (midAngle(d2) < Math.PI) then 1.0 else -1.0
				c = pos.join(",")
				res = "translate("+c+")"
				return res)
		.styleTween("text-anchor", (d) ->
			this._current = this._current || d
			interpolate = d3.interpolate(this._current, d);
			this._current = interpolate(0);
			return (t) ->
				d2 = interpolate(t);
				return if midAngle(d2) < Math.PI then "start" else "end")

	text.exit()
		.remove()

	#############################################################################
	# Poly Lines
	#############################################################################
	polyline = _svg.select(".lines")
		.selectAll("polyline")
		.data(pie(data), key)

	polyline.enter()
		.append("polyline")

	polyline.transition().duration(1000)
		.attrTween("points", (d) ->
			this._current = this._current || d
			interpolate = d3.interpolate(this._current, d)
			this._current = interpolate(0)
			return (t) ->
				d2 = interpolate(t)
				pos = outerArc.centroid(d2)
				pos[0] = radius * 0.95 * if (midAngle(d2) < Math.PI) then 1.0 else -1.0
				return [arc.centroid(d2), outerArc.centroid(d2), pos])

	polyline.exit()
		.remove()


#########################################################
# Persona Template
#########################################################

#########################################################
Template.persona.onCreated ->
	this.persona_id = Random.id()
	this.persona_wait_id = Random.id()
	this.persona_holder_id = Random.id()
	this.visible = new ReactiveVar(false)
	this.waiting = new ReactiveVar(false)
	this.renderable = new ReactiveVar(false)

#########################################################
Template.persona.onRendered ->
	this.renderable.set true

#########################################################
Template.persona.helpers
	persona_id: () ->
		instance = Template.instance()
		return instance.persona_id

	persona_wait_id: () ->
		instance = Template.instance()
		return instance.persona_wait_id

	persona_holder_id: () ->
		instance = Template.instance()
		return instance.persona_holder_id

	waiting: () ->
		instance = Template.instance()
		return instance.waiting.get()

	redraw: () ->
		instance = Template.instance()
		ready = instance.renderable.get()

		if not ready
			return

		id = instance.persona_id
		persona_wait_id = instance.persona_wait_id
		persona_holder_id = instance.persona_holder_id

		instance.$("#"+persona_holder_id).addClass("visible")
		instance.$("#"+persona_wait_id).addClass("waiting")

		Tracker.autorun () ->
			f = () ->
				_draw_persona instance.data.persona_data.get(), id
				instance.$("#"+persona_wait_id).removeClass("waiting")

			Meteor.setTimeout(f, 1000)

		return ""

