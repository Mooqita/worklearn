##########################################################
#
#	Moocita routes
#
##########################################################


##########################################################
# index
##########################################################

##########################################################
FlowRouter.route "/",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_landing"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/team",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_team"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/research",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_research"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/work-learn",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_work_learn"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/privacy",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_privacy"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/terms-of-use",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_terms"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/sign-in",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_login"
		BlazeLayout.render "body_template", data

##########################################################
# Student
##########################################################

##########################################################
FlowRouter.route "/user",
	name: "index",
	triggersEnter: [AccountsTemplates.ensureSignedIn],
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_view"
		BlazeLayout.render "body_template", data

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
