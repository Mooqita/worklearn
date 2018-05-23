###############################################################################
#
#	Mooqita routes
#
###############################################################################

###############################################################################
# import
###############################################################################

###############################################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter

###############################################################################
# index
###############################################################################

###############################################################################
FlowRouter.route "/",
	name: "land",
	action: (params) ->
		Session.set	"menu_template", null
		Session.set	"login_template", null
		Session.set	"footer_template", null

		Session.set	"layout_template", "mooqita_layout"
		Session.set	"content_template", "mooqita_landing"

		BlazeLayout.render "body_template", {base_url:"index"}


###############################################################################
# user routes
###############################################################################

###############################################################################
FlowRouter.route "/onboarding/:template",
	name: "onboarding",
	action: (params) ->
		Session.set	"menu_template", null
		Session.set	"login_template", null

		Session.set	"layout_template", "mooqita_layout"
		Session.set	"content_template", "mooqita_view"
		Session.set	"footer_template", "mooqita_footer"

		BlazeLayout.render "body_template", {base_url:"onboarding"}


###############################################################################
FlowRouter.route "/app/:template",
	name: "app",
	action: (params) ->
		Session.set	"menu_template", "mooqita_menu"
		Session.set	"login_template", "mooqita_login"
		Session.set	"layout_template", "mooqita_layout"
		Session.set	"content_template", "mooqita_view"
		Session.set	"footer_template", "mooqita_footer"

		BlazeLayout.render "body_template", {base_url:"app"}


###############################################################################
# basic routes
###############################################################################

###############################################################################
FlowRouter.route "/help",
	name: "help",
	action: (params) ->
		Session.set	"login_template", null

		Session.set	"menu_template", "mooqita_menu"
		Session.set	"layout_template", "mooqita_layout"
		Session.set	"content_template", "mooqita_help"
		Session.set	"footer_template", "mooqita_footer"

		BlazeLayout.render "mooqita_help", {base_url:"help"}


###############################################################################
# Terms
###############################################################################

###############################################################################
FlowRouter.route "/privacy",
	name: "privacy",
	action: (params) ->
		Session.set	"login_template", null

		Session.set	"menu_template", "mooqita_menu"
		Session.set	"layout_template", "mooqita_layout"
		Session.set	"content_template", "mooqita_privacy"
		Session.set	"footer_template", "mooqita_footer"

		BlazeLayout.render "mooqita_privacy", {base_url:"privacy"}

###############################################################################
FlowRouter.route "/terms-of-use",
	name: "terms-of-use",
	action: (params) ->
		Session.set	"login_template", null

		Session.set	"menu_template", "mooqita_menu"
		Session.set	"layout_template", "mooqita_layout"
		Session.set	"content_template", "mooqita_terms"
		Session.set	"footer_template", "mooqita_footer"

		BlazeLayout.render "mooqita_terms", {base_url:"terms"}


###############################################################################
#
#	Mooqita routes
#
###############################################################################

###############################################################################
FlowRouter.route '/admin',
	name: 'admin',
	action: (params) ->
		Session.set	"login_template", null

		Session.set	"menu_template", "mooqita_menu"
		Session.set	"layout_template", "mooqita_layout"
		Session.set	"content_template", "mooqita_admin"
		Session.set	"footer_template", "mooqita_footer"

		BlazeLayout.render "body_template", {base_url:"admin"}

