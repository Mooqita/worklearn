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


'''FlowRouter.route '/X',
	name: 'fourthPage',
	title: 'Fourth Page title',
	script:
		ldjson:
			type: 'application/ld+json',
			innerHTML: JSON.stringify({
				"@context": "http://schema.org/",
				"@type": "Recipe",
				"name": "Grandma's Holiday Apple Pie",
				"author": "Elaine Smith",
				"image": "http://images.edge-generalmills.com/56459281-6fe6-4d9d-984f-385c9488d824.jpg",
				"description": "A classic apple pie.",
				"aggregateRating":
					"@type": "AggregateRating",
					"ratingValue": "4",
					"reviewCount": "276",
					"bestRating": "5",
					"worstRating": "1"})
  action: () -> return "test"

'''