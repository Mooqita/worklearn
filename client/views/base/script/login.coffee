###############################################################################
# local variables and methods
###############################################################################

###############################################################################
FlowRouter = require("meteor/ostrio:flow-router-extra").FlowRouter

###############################################################################
_checkForm = (pwd1, pwd2) ->
	if(pwd1.value != "" && pwd1.value == pwd2.value)
		if(pwd1.value.length < 6)
			sAlert.error("Error: Password must contain at least six characters!")
			pwd1.focus()
			return false

		re = /[0-9]/
		if(!re.test(pwd1.value))
			sAlert.error("Error: password must contain at least one number (0-9)!")
			pwd1.focus()
			return false

		re = /[a-z]/
		if(!re.test(pwd1.value))
			sAlert.error("Error: password must contain at least one lowercase letter (a-z)!")
			pwd1.focus()
			return false

		re = /[A-Z]/
		if(!re.test(pwd1.value))
			sAlert.error("Error: password must contain at least one uppercase letter (A-Z)!")
			pwd1.focus()
			return false

	else
		sAlert.error("Error: Please check that you've entered and confirmed your password!")
		pwd1.focus()
		return false

	return true


###############################################################################
# login
###############################################################################

###############################################################################
Template.mooqita_login.events
	"click #linkedin": () ->
		Meteor.loginWithLinkedin (err) ->
			sAlert.error err

###############################################################################
# reset password
###############################################################################
Template.reset_password.events
	"submit #at-pwd-form": (e, t) ->
		e.preventDefault()

		token = Accounts._resetPasswordToken
		token = token.replace("=", "")

		pwd1 = t.find("#at-field-password")
		pwd2 = t.find("#at-field-password_again")

		if !_checkForm(pwd1, pwd2)
			return

		Accounts.resetPassword token, pwd1.value, (err) ->
			if (err)
				sAlert.error("We are sorry but something went wrong: " + err)
			else
				sAlert.success("Your password has been reset.")
				Accounts._resetPasswordToken = undefined
				Session.set "accounts_reset_password", undefined
				FlowRouter.go("/app/profile")

		return false
