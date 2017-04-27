#######################################################
#Created by Markus on 23/10/2015.
#Client
#######################################################

#Accounts.ui.config()

#worklearn
#TODO: remove visible_to from elements that do not need it.
#TODO: ensure user names are set and random avatar is assigned.
#TODO: move hash generation to server.
#TODO: template editor is not loading template code properly.
#TODO: make unique fields

#TODO: Students:Create profile
#TODO: Students:Link code revisions
#TODO: Students:give/receive reviews
#TODO: Students:Get credit

#TODO Companies: See profiles and credits
#TODO Companies: See details/code links is privileged access
#TODO All elements should be links not internal switches using: ?view=profile
#TODO Change color based on Text and or based on typing style

#Learning materials!!!!! I think we need to offer online classes that allow humans to code/write/design for the first time! Give credits to students for creating content?

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

AccountsTemplates.configureRoute('signIn');