##########################################################
#
#	Mooqita routes
#
##########################################################

##########################################################
FlowRouter.route '/admin',
	name: 'admin',
	action: (params) ->
		data =
			menu: "menu"
			login: "login"
			layout: "layout"
			content: "admin"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/response_dashboard",
	name: "response",
	action: (params) ->
		data =
			menu: "menu"
			login: "login_user"
			layout: "layout"
			content: "response_dashboard"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/response/:response_id",
	name: "response.id",
	action: (params) ->
		data =
			menu: "menu"
			login: "login_user"
			layout: "layout"
			content: "response_dashboard"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/template_dashboard",
	name: "template",
	action: (params) ->
		data =
			menu: "menu"
			login: "login_user"
			layout: "layout"
			content: "template_dashboard"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/template/:template_id",
	name: "template.id",
	action: (params) ->
		data =
			menu: "menu"
			login: "login_user"
			layout: "layout"
			content: "template_dashboard"
		BlazeLayout.render "body_template", data

