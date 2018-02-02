#########################################################
# locals
#########################################################

##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

#########################################################
#
# Persona
#
#########################################################

#########################################################
_draw_persona = (instance, width = 400, height = 200) ->
	data = instance.data.persona_data
	if not data
		console.log "no data"
		return

	id = instance.persona_id
	if not id
		console.log "no id"
		return

	if not data.has_text
		height = width

	radius = Math.min(width, height) / 2

	_svg = instance.svg.get()
	if not _svg
		console.log "found ", $("#" + id).size()
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

		_svg.attr("transform", "translate(" + ((width / 2) + 15) + "," + height / 2 + ")")
		instance.svg.set _svg

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
	if not data.has_text
		return

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
	this.persona_id = "id_" + Random.id()
	this.persona_wait_id = "id_" + Random.id()
	this.persona_holder_id = "id_" + Random.id()

	this.svg = new ReactiveVar(false)
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
				instance.$("#"+persona_wait_id).removeClass("waiting")
				_draw_persona instance

			Meteor.setTimeout(f, 500)

		return ""
