##########################################################
# login and accounts
##########################################################

##########################################################
AccountsTemplates.configure
	confirmPassword: true,
	enablePasswordChange: true,
	forbidClientAccountCreation: false,
	overrideLoginErrors: true,
	sendVerificationEmail: true,
	lowercaseUsername: true,
	focusFirstInput: true,

	#Appearance
	showAddRemoveServices: true,
	showForgotPasswordLink: true,
	showLabels: true,
	showPlaceholders: true,
	showResendVerificationEmailLink: true,

AccountsTemplates.removeField "password"
AccountsTemplates.addField
	_id: "password"
	type: "password"
	required: true
	minLength: 8
	#re: /(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])/
	#errStr: "At least 8 characters, 1 digit, 1 lower-case and 1 upper-case"
