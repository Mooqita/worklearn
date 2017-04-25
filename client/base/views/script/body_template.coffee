################################################
#
################################################

################################################
Template.body_template.onCreated ->
	try
		Fingerprint2 = require("fingerprintjs2")

		new Fingerprint2().get (result, components) ->
			Meteor.call "log_user", result,
				(err, res) ->
					if err
						console.log ["error", err]

	catch error
		console.log error

	self = this
	self.autorun ->
		filter =
			owner_id: Meteor.userId()
			type_identifier: "profile"

		Meteor.subscribe "responses", filter, "login_user"


################################################
Template.render_content.helpers
	ini_context: () ->
		ins = Template.instance()
		return ins.data
