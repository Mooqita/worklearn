########################################
Template.body_template.onCreated ->
	self = this

	self.autorun () ->
		console.log "param changed"
		item_id = FlowRouter.getQueryParam("item_id")
		template = FlowRouter.getQueryParam("template")

		if not template
			template = "student_profile"

		Session.set "current_data", Responses.findOne item_id
		Session.set "current_template", template

################################################
Template.body_template.helpers
	ini_context: () ->
		ins = Template.instance()
		return ins.data

########################################
Template.body_template.events
	"click .control-navigate": (event)->
		lnk = event.target.id
		if lnk
			param =
				template: lnk
			FlowRouter.setQueryParams param

