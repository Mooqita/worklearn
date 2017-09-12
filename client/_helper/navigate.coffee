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

##############################################
Template.registerHelper "g_get_menu", ()->
		Session.get "menu_template"

##############################################
Template.registerHelper "g_get_login", ()->
		Session.get "login_template"

##############################################
Template.registerHelper "g_get_layout", ()->
		Session.get "layout_template"

##############################################
Template.registerHelper "g_get_content", ()->
		Session.get "content_template"

##############################################
Template.registerHelper "g_get_footer", ()->
		Session.get "footer_template"

