###################################################
Template.template_editor.onRendered ->
	self = this
	self.autorun () ->
		tn = Session.get "current_template"
		console.log tn
		self.subscribe "template_by_id", tn

###################################################
Template.template_editor.helpers
	template_loaded: () ->
		tn = Session.get "current_template"

		tmpl = get_template_loaded(tn)
		if tmpl
			return true

		template = Templates.findOne(tn)
		if template.code == ""
			return true

		if not template.code
			return false

		tmpl_code = template.code
		compile_template tn, tmpl_code
		return true