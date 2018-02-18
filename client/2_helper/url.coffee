##############################################
Template.registerHelper "g_build_url", (template, query, base_name="app") ->
	if base_name.hash
		return build_url(template, query)

	return build_url(template, query, base_name, true)

