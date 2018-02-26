###############################################################################
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

###############################################################################
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

###############################################################################
@persona_map_job_to_person =
	Organizer: "Conscientiousness"
	Visionary: "Openness"
	Mediator: "Agreeableness"
	Manager: "Extroversion"
	Builder: "Stability"

###############################################################################
@persona_map_person_to_job =
	Conscientiousness: "Organizer"
	Agreeableness: "Mediator"
	Extroversion: "Manager"
	Stability: "Builder"
	Openness: "Visionary"

###############################################################################
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


###############################################################################
@persona_intermediate_to_vis = (inter)->
	res = []
	for t, v of inter
		r =
			label: t
			value: v
		res.push r

	return res


###############################################################################
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


###############################################################################
@persona_normalize = (a, w=undefined) ->
	if not w
		w = 0.0

		for t in a
			w += t.value

	for t in a
		t.value = t.value / w

	return a


###############################################################################
@persona_normalize_component = (a, min, max) ->
	a = persona_normalize(a)

	for t in a
		t.value = min + t.value * max

	return a


###############################################################################
@persona_add = (a, b) ->
	inter = {}

	for t in a
		inter[t.label] = t.value

	for t in b
		inter[t.label] += t.value

	return persona_intermediate_to_vis inter


###############################################################################
@persona_add_v = (a, v) ->
	inter = {}

	for t in a
		inter[t.label] = t.value + v

	return persona_intermediate_to_vis inter


###############################################################################
@persona_sub = (a, b) ->
	inter = {}

	for t in a
		inter[t.label] = t.value

	for t in b
		inter[t.label] -= t.value

	return persona_intermediate_to_vis inter


###############################################################################
@persona_mul = (a, b) ->
	inter = {}

	for t in a
		inter[t.label] = t.value

	for t in b
		inter[t.label] *= t.value

	return persona_intermediate_to_vis inter


###############################################################################
@persona_mul_v = (a, v) ->
	inter = {}

	for t in a
		inter[t.label] = t.value * v

	return persona_intermediate_to_vis inter


###############################################################################
@persona_div = (a, b) ->
	inter = {}

	for t in a
		inter[t.label] = t.value

	for t in b
		inter[t.label] /= t.value

	return persona_intermediate_to_vis inter


###############################################################################
@persona_div_v = (a, v) ->
	inter = {}

	for t in a
		inter[t.label] = t.value / v

	return persona_intermediate_to_vis inter


###############################################################################
@persona_invert = (a, max) ->
	inter = {}

	for t in a
		value = max - t.value
		inter[t.label] = if value > 0 then value else max / 20.0

	return persona_intermediate_to_vis inter


###############################################################################
@persona_extract_team = (team) ->
	n = team.length

	if n == 0
		return undefined

	avg =
		Conscientiousness: 0
		Agreeableness: 0
		Extroversion: 0
		Stability: 0
		Openness: 0

	for member in team
		if not member.big_five
			continue

		b5 = calculate_persona member.big_five
		for t in b5
			inv = t.value
			avg[t.label] = avg[t.label] + inv

	return persona_intermediate_to_vis avg


###############################################################################
@persona_build = (data) ->
	if not data
		return

	role = data["role"] || "other"
	idea = data["idea"] || 0
	team = data["team"] || 0
	soca = data["social"] || 0
	proc = data["process"] || 0
	stra = data["strategic"] || 0
	cont = data["contributor"] || 0

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
	org += team + proc								+ cont * 0.25
	med += team																			+ soca
	bui += 			+ proc								+ cont
	vis += 			+ stra	+ idea											+ soca * 0.25

	sum = man + org + med + bui + vis

	persona = [ { label: "Manager", value: Math.round(man / sum * 100)},
							{ label: "Organizer", value: Math.round(org / sum * 100) },
							{ label: "Mediator", value: Math.round(med / sum * 100) },
							{ label: "Builder", value: Math.round(bui / sum * 100) },
							{ label: "Visionary", value: Math.round(vis / sum * 100) } ]

	return persona


###############################################################################
@percentile = (score, mean, sd) ->
	Z_MAX = 6
	d = score - mean
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

