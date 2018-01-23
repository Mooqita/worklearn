##########################################################
#
# Accounts setup
#
##########################################################

#######################################################
_on_reg_submit = (err, state) ->
	sAlert.error err
	sAlert.info state
	if not err
		Modal.hide "onboarding_register"

	return state


#######################################################
_pre_sign_up = (pswd, options) ->
	occupation = Session.get "user_occupation"
	options.profile.occupation = occupation


##########################################################
AccountsTemplates.configure
	# Client-side Validation
	continuousValidation: true,
	negativeFeedback: true,
	negativeValidation: true,
	positiveValidation: true,
	positiveFeedback: true,
	showValidating: true,

	onSubmitHook: _on_reg_submit
	preSignUpHook: _pre_sign_up
	# Privacy Policy and Terms of Use
	# privacyUrl: 'privacy',
	# termsUrl: 'terms-of-use',
