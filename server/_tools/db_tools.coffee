#######################################################
_accepts =
	type_identifier: String
	challenge_id: non_empty_string
	solution_id: non_empty_string
	template_id: non_empty_string
	group_name: String
	parent_id: non_empty_string
	owner_id: non_empty_string
	index: Match.OneOf String, Number
	text: String
	_id: non_empty_string

#######################################################
@make_filter_save = (user_id, param) ->
	check user_id, Match.OneOf String, undefined, null

	restrict = {}

	for field_name, value of _accepts
		if field_name of param
			check param[field_name], value
			if field_name == "text"
				restrict["$text"] =
					$search: param[field_name]
			else
				restrict[field_name] = param[field_name]

	return restrict


#######################################################
@log_publication = (crs, filter, fields, mine, header_only, origin) ->
	data = if header_only then "without data" else "with data"
	console.log "Submitted " + crs.count() + " responses " + data + " to " + origin

#	f = JSON.stringify(filter, null, 2);
#	console.log f

#	console.log "With fields"

#	m = JSON.stringify(fields, null, 2);
#	console.log m

