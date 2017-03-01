########################################
# load_template
########################################

########################################
@get_compiled_template = (template_id)->
	template = Template[template_id]

	if template
		return template

@get_template = (template_id)->
	template = Templates.findOne(template_id)

	return template


########################################
Template.dynamic_template_loader.onCreated ->
	self = this
	self.autorun () ->
		template_id = self.data.template_id
		self.subscribe "template_by_id", template_id

########################################
Template.dynamic_template_loader.helpers
	template_exists: ->
		tn = this.template_id

		tmpl = get_template(tn)
		if tmpl
			return true

		tmpl = get_compiled_template(tn)
		if tmpl
			return true

		return false

	template_loaded: ->
		tn = this.template_id

		tmpl = get_compiled_template(tn)
		if tmpl
			return true

		template = Templates.findOne(tn)
		if not template.code
			return false

		tmpl_code = template.code
		compile_template tn, tmpl_code
		return true
