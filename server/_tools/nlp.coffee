_collect_fields = (response, fields) ->
	corpus = ""
	for field, v of fields
		text = response[field]
		if typeof text == "string"
			corpus += " " + text

	return corpus


@collect_keywords = (user) ->
	keywords = {}
	corpus = ""

	fl_sol =
		type_identifier: "solution"
		owner_id: user._id

	fields =
		content: 1
		title: 1
		name: 1

	mod =
		fields:
			parent_id: 1
			content: 1
			title: 1
			name: 1

	solutions = Responses.find(fl_sol, mod).fetch()

	for solution in solutions
		p_id = solution.parent_id
		challenge = Responses.findOne p_id, mod
		corpus += _collect_fields solution, fields
		corpus += _collect_fields challenge, fields

	corpus = corpus.replace(/<\/?[^>]+(>|$)/g, "")
	return corpus

