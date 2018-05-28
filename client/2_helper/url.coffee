##############################################
Template.registerHelper "g_build_url", (template, query, base_name="app", login_type="") ->
	if base_name.hash
		url = build_url(template, query)
	else
		url = build_url(template, query, base_name, true)

	if login_type
		if not login_type.hash
			url += "&nlg="+login_type

	return url

