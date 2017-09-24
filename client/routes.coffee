##########################################################
#
#	Mooqita routes
#
##########################################################

##########################################################
# import
##########################################################

##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

##########################################################
# index
##########################################################

##########################################################
FlowRouter.route "/",
	name: "index",
	action: (params) ->
		Session.set	"menu_template", "mooqita_menu"
		Session.set	"login_template", "mooqita_login"
		Session.set	"layout_template", "mooqita_layout"
		Session.set	"content_template", "mooqita_landing"
		Session.set	"footer_template", "mooqita_footer"

		this.render "body_template"


##########################################################
# user routes
##########################################################

##########################################################
FlowRouter.route "/app/:template",
	name: "index",
	action: (params) ->
		Session.set	"menu_template", "mooqita_menu"
		Session.set	"login_template", "mooqita_login"
		Session.set	"layout_template", "mooqita_layout"
		Session.set	"content_template", "mooqita_view"
		Session.set	"footer_template", "mooqita_footer"

		this.render "body_template"

##########################################################
# basic routes
##########################################################

##########################################################
FlowRouter.route "/help",
	name: "index",
	action: (params) ->
		Session.set	"menu_template", "mooqita_menu"
		Session.set	"layout_template", "mooqita_layout"
		Session.set	"content_template", "mooqita_help"
		Session.set	"footer_template", "mooqita_footer"

		this.render "body_template"


##########################################################
# Terms
##########################################################

##########################################################
FlowRouter.route "/privacy",
	name: "privacy",
	action: (params) ->
		Session.set	"menu_template", "mooqita_menu"
		Session.set	"layout_template", "mooqita_layout"
		Session.set	"content_template", "mooqita_privacy"
		Session.set	"footer_template", "mooqita_footer"

		this.render "body_template"

##########################################################
FlowRouter.route "/terms-of-use",
	name: "terms-of-use",
	action: (params) ->
		Session.set	"menu_template", "mooqita_menu"
		Session.set	"layout_template", "mooqita_layout"
		Session.set	"content_template", "mooqita_terms"
		Session.set	"footer_template", "mooqita_footer"

		this.render "body_template"


##########################################################
#
#	Mooqita routes
#
##########################################################

##########################################################
FlowRouter.route '/admin',
	name: 'admin',
	action: (params) ->
		Session.set	"menu_template", "mooqita_menu"
		Session.set	"layout_template", "mooqita_layout"
		Session.set	"content_template", "mooqita_admin"

		this.render "body_template"