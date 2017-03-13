########################################
# load_template
########################################

########################################
Template.dynamic_template_loader.onCreated ->
	self = this
	self.autorun () ->
		template_id = self.data.template_id
		template = get_template_local(template_id)
		if not template
			self.subscribe "template_by_id", template_id

########################################
Template.dynamic_template_loader.helpers
	template_exists: ->
		tn = this.template_id

		tmpl = get_template_local(tn)
		if tmpl
			return true

		tmpl = get_compiled_template(tn)
		if tmpl
			return true

		return false

	template_compiled: ->
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
