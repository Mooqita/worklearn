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
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/team",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_team"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/research",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_research"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/help",
	name: "index",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_help"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/work-learn",
	name: "worklearn",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_work_learn"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/privacy",
	name: "privacy",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_privacy"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/terms-of-use",
	name: "terms-of-use",
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_terms"
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
	showResendVerificationEmailLink: true,

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
# Student
##########################################################

##########################################################
FlowRouter.route "/user",
	name: "index",
	triggersEnter: [AccountsTemplates.ensureSignedIn],
	action: (params) ->
		data =
			menu: "mooqita_menu"
			layout: "mooqita_layout"
			content: "mooqita_view"
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

##########################################################
FlowRouter.route "/response_dashboard",
	name: "response",
	action: (params) ->
		data =
			menu: "menu"
			login: "login_user"
			layout: "layout"
			content: "response_dashboard"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/response/:response_id",
	name: "response.id",
	action: (params) ->
		data =
			#menu: "menu"
			#login: "login_user"
			#layout: "layout"
			content: "response_dashboard"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/template_dashboard",
	name: "template",
	action: (params) ->
		data =
			menu: "menu"
			login: "login_user"
			layout: "layout"
			content: "template_dashboard"
		BlazeLayout.render "body_template", data

##########################################################
FlowRouter.route "/template/:template_id",
	name: "template.id",
	action: (params) ->
		data =
			menu: "menu"
			login: "login_user"
			layout: "layout"
			content: "template_dashboard"
		BlazeLayout.render "body_template", data
