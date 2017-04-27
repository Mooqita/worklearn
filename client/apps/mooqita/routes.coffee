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

