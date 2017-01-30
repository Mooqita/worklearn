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
FlowRouter.route('/file/:collection/:item_id/:field/:file_name',
	name: 'file',
	action: (params) ->
		BlazeLayout.render("base_layout", {content: 'file_download'}))

##########################################################
FlowRouter.route('/admin',
	name: 'admin',
	action: (params) ->
		BlazeLayout.render("base_layout", {content: 'admin'}))

