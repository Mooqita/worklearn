##########################################################
#
#	Moocita routes
#
##########################################################

##########################################################
# index
##########################################################

##########################################################
FlowRouter.route('/',
	name: 'index',
	action: (params) ->
		BlazeLayout.render("main_layout", {content: 'landing'}))

##########################################################
# responses
##########################################################

##########################################################
FlowRouter.route('/response_dashboard',
	name: 'response',
	action: (params) ->
		BlazeLayout.render("main_layout", {content: 'response_dashboard'}))

##########################################################
FlowRouter.route('/r/:response_id',
	name: 'response.id',
	action: (params) ->
		BlazeLayout.render("main_layout", {content: 'login_user'}))

##########################################################
# admin stuff
##########################################################

##########################################################
FlowRouter.route('/admin',
	name: 'admin',
	action: (params) ->
		BlazeLayout.render("main_layout", {content: 'admin'}))

