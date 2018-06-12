#########################################################
# locals
#########################################################

##########################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter
d3 = require("d3")

##########################################################
_default_persona = [ { label: "Manager", value: 1 },
										 { label: "Organizer", value: 1 },
										 { label: "Mediator", value: 1 },
										 { label: "Builder", value: 1 },
										 { label: "Visionary", value: 1 } ]

#########################################################
#
# Persona
#
#########################################################

#########################################################
_draw_persona = (instance, width = 400, height = 200) ->
	data = instance.data
	persona = data.persona_data
	is_ready = true

	if not persona
		console.log "persona not defined"
		persona = _default_persona
		is_ready = false

	id = instance.persona_id
	if not id
		console.log "no id"
		return

	width = data.width || width
	height = data.height || height

	has_text = data.has_text
	radius = Math.min(width, height) / 2

	_svg = instance.svg.get()
	if not _svg
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

		tx = (width / 2) + (data.offset_x || 0)
		ty = (height / 2) + (data.offset_y || 0)

		_svg.attr("transform", "translate(" + tx + "," + ty + ")")
		instance.svg.set _svg

	in_c = if has_text then 0.45 else 0.5
	mid_c = if has_text then 0.85 else 0.99
	out_c = if has_text then 0.9 else 0.99

	arc = d3.arc()
		.outerRadius(radius * mid_c)
		.innerRadius(radius * in_c)

	outerArc = d3.arc()
		.innerRadius(radius * out_c)
		.outerRadius(radius * out_c)

	sorter = (a, b) ->
		return a.label.localeCompare(b.label)

	pie = d3.pie()
		.sort(sorter)
		.value (d) ->
			return d.value

	key = (d) ->
		return d.data.label

	color_map =
		Manager:"#98abc5"
		Builder:"#8a89a6"
		Mediator:"#7b6888"
		Organizer:"#6b486b"
		Visionary:"#a05d56"

	color_map = ["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56"]

	color_mapping = (d) ->
		return color_map[d.index]

	#############################################################################
	# Donut Slices
	#############################################################################
	slice = _svg.select(".slices")
		.selectAll("path.slice")
		.data(pie(persona), key)

	slice.enter()
		.insert("path")
		.style("fill", color_mapping )
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
	if not has_text
		return is_ready

	#############################################################################
	midAngle = (d) ->
		return d.startAngle + (d.endAngle - d.startAngle) / 2

	#############################################################################
	text = _svg.select(".labels")
		.selectAll("text")
		.data(pie(persona), key)

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
		.data(pie(persona), key)

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

	return is_ready


#########################################################
# Persona Template
#########################################################

#########################################################
Template.persona.onCreated ->
	this.persona_id = "id_" + Random.id()
	this.persona_wait_id = "id_" + Random.id()
	this.persona_holder_id = "id_" + Random.id()

	this.svg = new ReactiveVar(false)
	this.ready = new ReactiveVar(false)
	this.visible = new ReactiveVar(false)
	this.waiting = new ReactiveVar(false)
	this.renderable = new ReactiveVar(false)

#########################################################
Template.persona.onRendered ->
	instance = Template.instance()
	ready = _draw_persona instance

	instance.ready.set ready
	instance.renderable.set true

#########################################################
Template.persona.helpers
	data_ready: () ->
		instance = Template.instance()
		ready = instance.ready.get()
		return ready

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
		renderable = instance.renderable.get()

		if not renderable
			return

		id = instance.persona_id
		persona_wait_id = instance.persona_wait_id
		persona_holder_id = instance.persona_holder_id

		instance.$("#"+persona_holder_id).addClass("visible")
		instance.$("#"+persona_wait_id).addClass("waiting")

		Tracker.autorun () ->
			f = () ->
				instance.$("#"+persona_wait_id).removeClass("waiting")
				ready = _draw_persona instance
				instance.ready.set ready

			Meteor.setTimeout(f, 500)

		return ""
