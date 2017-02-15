########################################
Template.worker_login.onCreated ->
	self = this
	self.autorun () ->


########################################
Template.worker_login.helpers
	template_exists: ->
		return Template[FlowRouter.getParam("template")]

	template_path: ->
		return FlowRouter.getParam("template")


########################################
Template.sign_worker.events
	'submit #id_form': (event) ->
		event.preventDefault()
		target = event.target
		id = target.worker_id.value

		Meteor.call 'sign_in_worker', id,
			(err, rsp)->
				if err
					console.log err
					sAlert.error 'We could not log you in! ' + err
				else
					console.log rsp
					Meteor.loginWithToken rsp.token,
						(err, rsp)->
							if err
								console.log err
								sAlert.error 'We could not log you in! ' + err
							else
								console.log rsp
								target.worker_id.value = ''
								sAlert.success('You are logged in.')
