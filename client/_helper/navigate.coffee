##############################################
Template.registerHelper "build_url", (template, query) ->
	return build_url(template, query)

##############################################
Template.registerHelper "profile_url", (type) ->
	if type == "student"
		return build_url "student_profile"

	if type == "company"
		return build_url "company_profile"

	return build_url "student_profile"
