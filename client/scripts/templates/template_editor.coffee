###################################################
#
# Dashboard for template editing
#
###################################################

###################################################
Template.template_dashboard.onCreated ->
	self = this
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
# loader
#
###################################################

###################################################
Template.template_editor_load.onCreated ->
	console.log "created"

###################################################
Template.template_editor_load.onRendered ->
	this.loaded = new ReactiveVar(false)
	console.log "rendered"
	self = this
	self.autorun () ->
		tn = self.data._id
		self.subscribe "template_by_id", tn,
			onReady: ()->
				console.log "subscribed template by id"
				self.loaded.set(true)

###################################################
Template.template_editor_load.helpers
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
			console.log "found compiled"
			return true

		template = Templates.findOne(tn)
		if template.code == ""
			console.log "code is empty"
			return true

		if not template.code
			console.log "code not found"
			return false

		tmpl_code = template.code
		compile_template tn, tmpl_code
		console.log "code compiled"

		return true

	template: () ->
		tn = Template.instance().data._id
		template = Templates.findOne(tn)
		return template

