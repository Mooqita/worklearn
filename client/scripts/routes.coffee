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
		BlazeLayout.render("full_width_layout", {content: 'landing'}))

##########################################################
# template stuff
##########################################################

##########################################################
FlowRouter.route('/template_dashboard',
	name: 'challenge',
	action: (params) ->
		BlazeLayout.render("base_layout", {content: 'template_dashboard'}))

##########################################################
FlowRouter.route('/template_dashboard/:template_id',
	name: 'challenge',
	action: (params) ->
		BlazeLayout.render("base_layout", {content: 'template_dashboard'}))

##########################################################
# responses
##########################################################

##########################################################
FlowRouter.route('/response_dashboard',
	name: 'response',
	action: (params) ->
		BlazeLayout.render("base_layout", {content: 'response_dashboard'}))

##########################################################
FlowRouter.route('/response_dashboard/:response_id',
	name: 'response',
	action: (params) ->
		BlazeLayout.render("empty_layout", {content: 'response_dashboard'}))

##########################################################
FlowRouter.route('/:template_id/:index',
	name: 'index',
	action: (params) ->
		BlazeLayout.render("empty_layout", {content: 'auto_login'}))


##########################################################
# admin stuff
##########################################################

##########################################################
FlowRouter.route('/admin',
	name: 'admin',
	action: (params) ->
		BlazeLayout.render("base_layout", {content: 'admin'}))

##########################################################
FlowRouter.route('/file/:collection/:item_id/:field/:file_name',
	name: 'file',
	action: (params) ->
		BlazeLayout.render("base_layout", {content: 'file_download'}))

