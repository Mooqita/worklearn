###############################################################################
#
# Entry point for all templates
#
###############################################################################

###############################################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter

###############################################################################
Template.registerHelper "layout_selected_menu", ()->
	Session.get "menu_template"

###############################################################################
Template.registerHelper "layout_selected_login", ()->
	Session.get "login_template"

##############################################
Template.registerHelper "layout_selected_layout", ()->
	Session.get "layout_template"

###############################################################################
Template.registerHelper "layout_selected_content", ()->
	Session.get "content_template"

###############################################################################
Template.registerHelper "layout_selected_footer", ()->
	Session.get "footer_template"

###############################################################################
Template.registerHelper "layout_selected_view", ()->
	selected = FlowRouter.getParam("template")
	if not selected
		selected = "landing_page"
	return selected

###############################################################################
Template.profile_loader.onCreated ->
	Meteor.call "log_user",
		(err, res) ->
			if err
				console.log ["error", err]


