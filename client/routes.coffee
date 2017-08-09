##########################################################
#
#	Moocita routes
#
##########################################################


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
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/team",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_team"
			footer: "mooqita_footer"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/research",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_research"
			footer: "mooqita_footer"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/help",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_help"
			footer: "mooqita_footer"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/bugs",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_bugs"
			footer: "mooqita_footer"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/about",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_about"
			footer: "mooqita_footer"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/work-learn",
	name: "worklearn",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_work_learn"
			footer: "mooqita_footer"
		BlazeLayout.render "body_template", data

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
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/terms-of-use",
	name: "terms-of-use",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_terms"
			footer: "mooqita_footer"
		BlazeLayout.render "body_template", data

##########################################################
# login and accounts
##########################################################

##########################################################
FlowRouter.route "/login",
	name: "user.signin",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_login"
			footer: "mooqita_footer"
		BlazeLayout.render "body_template", data

##########################################################
AccountsTemplates.configure
	confirmPassword: true,
	enablePasswordChange: true,
	forbidClientAccountCreation: false,
	overrideLoginErrors: true,
	sendVerificationEmail: true,
	lowercaseUsername: false,
	focusFirstInput: true,

	#Appearance
	showAddRemoveServices: true,
	showForgotPasswordLink: true,
	showLabels: true,
	showPlaceholders: true,
	showResendVerificationEmailLink: false,

	# Client-side Validation
	continuousValidation: false,
	negativeFeedback: false,
	negativeValidation: true,
	positiveValidation: true,
	positiveFeedback: true,
	showValidating: true,

	# Privacy Policy and Terms of Use
	privacyUrl: 'privacy',
	termsUrl: 'terms-of-use',

##########################################################
AccountsTemplates.configureRoute 'signIn',
	path: '/login'

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
		BlazeLayout.render "body_template", data

##########################################################
#
#	Mooqita routes
#
##########################################################

##########################################################
FlowRouter.route '/admin',
	name: 'admin',
	action: (params) ->
		data =
			menu: "menu"
			layout: "layout"
			content: "admin"
		BlazeLayout.render "body_template", data

