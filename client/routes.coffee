##########################################################
#
#	Mooqita routes
#
##########################################################

##########################################################
# import
##########################################################

##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

##########################################################
# index
##########################################################

##########################################################
FlowRouter.route "/",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_landing"
			footer: "mooqita_footer"
		this.render "mooqita_landing"


##########################################################
FlowRouter.route "/help",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_help"
			footer: "mooqita_footer"
		this.render "body_template", data


##########################################################
# Terms
##########################################################

##########################################################
FlowRouter.route "/privacy",
	name: "privacy",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_privacy"
			footer: "mooqita_footer"
		this.render "body_template", data

##########################################################
FlowRouter.route "/terms-of-use",
	name: "terms-of-use",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_terms"
			footer: "mooqita_footer"
		this.render "body_template", data


##########################################################
# user routes
##########################################################

##########################################################
FlowRouter.route "/app/:template",
	name: "index",
	triggersEnter: [AccountsTemplates.ensureSignedIn],
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_view"
			footer: "mooqita_footer"
		this.render "body_template", data

##########################################################
#
#	Mooqita routes
#
##########################################################

##########################################################
'''FlowRouter.route '/admin',
	name: 'admin',
	action: (params) ->
		console.log "admin"
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_admin"
		this.render "body_template", data

'''