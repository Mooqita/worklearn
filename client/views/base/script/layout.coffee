################################################
#
# Entry point for all templates
#
################################################

##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

##############################################
Template.registerHelper "layout_selected_menu", ()->
	Session.get "menu_template"

##############################################
Template.registerHelper "layout_selected_login", ()->
	Session.get "login_template"

##############################################
Template.registerHelper "layout_selected_layout", ()->
	Session.get "layout_template"

##############################################
Template.registerHelper "layout_selected_content", ()->
	Session.get "content_template"

##############################################
Template.registerHelper "layout_selected_footer", ()->
	Session.get "footer_template"

##############################################
Template.registerHelper "layout_selected_view", ()->
	selected = FlowRouter.getParam("template")
	if not selected
		selected = "landing_page"
	return selected


################################################
Template.profile_loader.onCreated ->
	self = this

	Meteor.call "log_user",
		(err, res) ->
			if err
				console.log ["error", err]

	self.autorun ->
		self.subscribe "my_profile",
			(err, res) ->
				if err
					sAlert.error "Profile subscription error: " + err
					console.log err

		# TODO: might get slow for n > X000 (150 Byte each.)
		# this can happen if the user has a very large number
		# of admissions. Not very likely at the moment though.
		self.subscribe "my_admissions",
			(err, res) ->
				if err
					sAlert.error "Admissions subscription error: " + err
					console.log err


