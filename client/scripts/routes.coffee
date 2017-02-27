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
FlowRouter.route('/admin',
	name: 'admin',
	action: (params) ->
		BlazeLayout.render("base_layout", {content: 'admin'}))

##########################################################
FlowRouter.route('/file/:collection/:item_id/:field/:file_name',
	name: 'file',
	action: (params) ->
		BlazeLayout.render("base_layout", {content: 'file_download'}))

##########################################################
FlowRouter.route('/challenge_dashboard',
	name: 'challenge',
	action: (params) ->
		BlazeLayout.render("base_layout", {content: 'challenge_dashboard'}))

##########################################################
FlowRouter.route('/challenge_dashboard/:challenge_id',
	name: 'challenge_editor',
	action: (params) ->
		BlazeLayout.render("base_layout", {content: 'challenge_dashboard'}))

##########################################################
FlowRouter.route('/response/:challenge_id/:index',
	name: 'response',
	action: (params) ->
		BlazeLayout.render("base_layout", {content: 'worker_login'}))


