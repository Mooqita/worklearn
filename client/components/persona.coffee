#########################################################
@persona_job = [ { label: "Manager", value: 1 },
										 { label: "Organizer", value: 1 },
										 { label: "Mediator", value: 1 },
										 { label: "Builder", value: 1 },
										 { label: "Visionary", value: 1 } ]

@persona_big_5 = [{ label: "Stability", value: 1 },
									{ label: "Openness", value: 1 },
									{ label: "Agreeableness", value: 1 },
									{ label: "Extroversion", value: 1 },
									{ label: "Conscientiousness", value: 1 } ]

#########################################################
@persona_role_map =
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
@persona_map_job_to_person =
	Organizer: "Conscientiousness"
	Visionary: "Openness"
	Mediator: "Agreeableness"
	Manager: "Extroversion"
	Builder: "Stability"

#########################################################
@persona_map_person_to_job =
	Conscientiousness: "Organizer"
	Agreeableness: "Mediator"
	Extroversion: "Manager"
	Stability: "Builder"
	Openness: "Visionary"

#########################################################
@persona_optimize_team = (team, job) ->
	max_change = 0.2

	team = persona_normalize(team)
	team = persona_map team, persona_map_person_to_job

	job = persona_normalize(job)

	j_sq = persona_mul(job, job)

	j_min = persona_mul_v(j_sq, max_change)
	j_min = persona_sub(job, j_min)

	j_max = persona_mul_v(j_sq, -1)
	j_max = persona_add_v(j_max, 1)
	j_max = persona_mul_v(j_max, max_change)
	j_max = persona_add(job, j_max)

	dif = persona_sub(team, job)
	dif = persona_add_v(dif, 1)
	dif = persona_div_v(dif, 2)

	res = persona_sub(j_max, j_min)
	res = persona_mul(dif, res)
	res = persona_add(res, j_min)

	return res


#########################################################
@persona_intermediate_to_vis = (inter)->
	res = []
	for t, v of inter
		r =
			label: t
			value: v
		res.push r

	return res


#########################################################
@persona_map = (a, map) ->
	inter = {}

	if not a
		return a

	if not (a.length > 0)
		return a

	for t in a
		label = t.label
		if map
			label = map[label]
		inter[label] = t.value

	return persona_intermediate_to_vis inter


#########################################################
@persona_normalize = (a, w=undefined) ->
	if not w
		w = 0.0

		for t in a
			w += t.value

	for t in a
		t.value = t.value / w

	return a


#########################################################
@persona_add = (a, b) ->
	inter = {}

	for t in a
		inter[t.label] = t.value

	for t in b
		inter[t.label] += t.value

	return persona_intermediate_to_vis inter


#########################################################
@persona_add_v = (a, v) ->
	inter = {}

	for t in a
		inter[t.label] = t.value + v

	return persona_intermediate_to_vis inter


#########################################################
@persona_sub = (a, b) ->
	inter = {}

	for t in a
		inter[t.label] = t.value

	for t in b
		inter[t.label] -= t.value

	return persona_intermediate_to_vis inter


#########################################################
@persona_mul = (a, b) ->
	inter = {}

	for t in a
		inter[t.label] = t.value

	for t in b
		inter[t.label] *= t.value

	return persona_intermediate_to_vis inter


#########################################################
@persona_mul_v = (a, v) ->
	inter = {}

	for t in a
		inter[t.label] = t.value * v

	return persona_intermediate_to_vis inter


#########################################################
@persona_div = (a, b) ->
	inter = {}

	for t in a
		inter[t.label] = t.value

	for t in b
		inter[t.label] /= t.value

	return persona_intermediate_to_vis inter


#########################################################
@persona_div_v = (a, v) ->
	inter = {}

	for t in a
		inter[t.label] = t.value / v

	return persona_intermediate_to_vis inter


#########################################################
@persona_invert = (a, max) ->
	inter = {}

	for t in a
		value = max - t.value
		inter[t.label] = if value > 0 then value else 0.01

	return persona_intermediate_to_vis inter


#########################################################
@persona_extract_requirements = (team) ->
	n = team.length

	if n == 0
		return undefined

	avg =
		Conscientiousness: 0
		Agreeableness: 0
		Extroversion: 0
		Stability: 0
		Openness: 0

	n = 0
	for member in team
		if not member.big_five
			continue

		b5 = calculate_persona_40 member.big_five
		n += 1

		for t in b5
			inv = t.value
			avg[t.label] = avg[t.label] + inv

	if n == 0
		return undefined

	for l in avg
		avg[l] /= n

	return persona_intermediate_to_vis avg


#########################################################
@persona_build = (data) ->
	if not data
		return

	role = data["role"] || "other"
	idea = data["idea"] || 0
	team = data["team"] || 0
	proc = data["process"] || 0
	stra = data["strategic"] || 0

	base = 0.1

	man = base
	org = base
	med = base
	bui = base
	vis = base

	if role
		man += persona_role_map[role]["manager"]
		org += persona_role_map[role]["organizer"]
		med += persona_role_map[role]["mediator"]
		bui += persona_role_map[role]["builder"]
		vis += persona_role_map[role]["visionary"]

	man += team + proc * 0.25 + stra
	org += team + proc
	med += team
	bui += 			+ proc
	vis += 			+ stra	+ idea

	sum = man + org + med + bui + vis

	persona = [ { label: "Manager", value: man / sum },
							{ label: "Organizer", value: org / sum },
							{ label: "Mediator", value: med / sum },
							{ label: "Builder", value: bui / sum },
							{ label: "Visionary", value: vis / sum } ]

	return persona


