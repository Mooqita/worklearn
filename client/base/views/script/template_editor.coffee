###################################################
#
# Dashboard for template editing
#
###################################################

###################################################
Template.template_dashboard.onCreated ->
	template_id = FlowRouter.getParam("template_id")

###################################################
Template.template_dashboard.events
	"click #add_template": () ->
		Meteor.call "add_template",
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.info("template added")

###################################################
Template.template_dashboard.helpers
	template: () ->
		id = FlowRouter.getParam("template_id")
		res = Templates.findOne(id)
		return res

	templates: () ->
		return Templates.find()

	template_url: () ->
		return "/template_dashboard/"+this._id


###################################################
#
# editor
#
###################################################

###################################################
Template.template_editor.onCreated ->
	this.loaded = new ReactiveVar(false)
	self = this
	self.autorun () ->
		tn = self.data._id
		self.subscribe "template_by_id", tn, false,
			onReady: ()->
				self.loaded.set(true)

###################################################
Template.template_editor.helpers
	template_exists: () ->
		tn = Template.instance().data._id
		tmpl = Templates.findOne(tn)

		if tmpl
			return true

		return false

	template_loaded: () ->
		inst = Template.instance()

		if inst.loaded
			return inst.loaded.get()

		return false

	template_compiled: () ->
		tn = Template.instance().data._id

		tmpl = get_compiled_template(tn)
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

	template: () ->
		tn = Template.instance().data._id
		template = Templates.findOne(tn)
		return template

	response_url: () ->
		return "/response/"+this._id+"/1"


###################################################
#
# template edit toggle
#
###################################################

###################################################
Template._edit_template_toggle.events
	'click #edit': () ->
		ed = Session.get("editing_template")

		if ed == this.template._id
			Session.set("editing_template", "")
			return

		Session.set("editing_template", this.template._id)

