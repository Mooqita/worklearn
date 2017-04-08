Template.select_template.helpers
	templates: () ->
		return find_template_names()

Template.select_response.helpers
	responses: () ->
		return find_response_names()
