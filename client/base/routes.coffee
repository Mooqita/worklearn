##########################################################
#
#	Moocita routes
#
##########################################################

##########################################################
FlowRouter.route '/admin',
	name: 'admin',
	action: (params) ->
		data =
			content: "admin"
			login: "login"
			menu: "menu"
		BlazeLayout.render "admin", data

##########################################################
FlowRouter.route "/response_dashboard",
	name: "response",
	action: (params) ->
		data =
			content: "response_dashboard"
			login: "login_user"
			menu: "menu"
			layout: "layout"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/response/:response_id",
	name: "response.id",
	action: (params) ->
		data =
			login: "login_user"
		BlazeLayout.render "body_template", data

