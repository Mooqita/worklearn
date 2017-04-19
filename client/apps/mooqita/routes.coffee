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
		BlazeLayout.render("mooqita_landing")

##########################################################
FlowRouter.route "/team",
	name: "index",
	action: (params) ->
		BlazeLayout.render("mooqita_team")

##########################################################
FlowRouter.route "/research",
	name: "index",
	action: (params) ->
		BlazeLayout.render("mooqita_research")

##########################################################
# Student
##########################################################

##########################################################
FlowRouter.route "/student",
	name: "index",
	action: (params) ->
		data =
			content: "student_view"
			login: "login"
			menu: "mooqita_menu"
		BlazeLayout.render "body_template", data

##########################################################
# Company
##########################################################

##########################################################
FlowRouter.route "/company",
	name: "index",
	action: (params) ->
		BlazeLayout.render("mooqita_company")
