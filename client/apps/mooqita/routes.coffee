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
FlowRouter.route "/s",
	name: "index",
	action: (params) ->
		BlazeLayout.render("mooqita_student", )

##########################################################
# Student
##########################################################

##########################################################
FlowRouter.route "/c",
	name: "index",
	action: (params) ->
		BlazeLayout.render("mooqita_company")
