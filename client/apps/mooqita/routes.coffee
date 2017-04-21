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
# Student
##########################################################

##########################################################
FlowRouter.route "/std",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			login: "mooqita_login"
			layout: "mooqita_layout"
			content: "mooqita_view"
		BlazeLayout.render "body_template", data

##########################################################
# Company
##########################################################

##########################################################
FlowRouter.route "/rec",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			login: "mooqita_login"
			layout: "mooqita_layout"
			content: "mooqita_view"
		BlazeLayout.render "body_template", data
