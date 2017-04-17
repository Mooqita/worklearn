'''
########################################
Template.sign_worker.events
	"submit #id_form": (event) ->
		event.preventDefault()
		target = event.target
		id = target.worker_id.value

		Meteor.call "sign_in_worker", id,
			(err, rsp)->
				if err
					sAlert.error "We could not log you in! " + err
				else
					Meteor.loginWithToken rsp.token,
						(err, rsp)->
							if err
								sAlert.error "We could not log you in! " + err
							else
								target.worker_id.value = ""
								sAlert.success("You are logged in.")


	if Meteor.userId()
		return

	Fingerprint2 = require('fingerprintjs2')

	new Fingerprint2().get (result) ->
		Session.set "fng_pr", result
		Meteor.call "log_user", result

		Meteor.call "sign_in_worker", result,
			(err, rsp)->
				if err
					sAlert.error "We could not log you in! " + err
				else
					Meteor.loginWithToken rsp.token,
						(err, rsp)->
							if err
								sAlert.error "We could not log you in! " + err
							else
								sAlert.success("You are logged in.")
'''