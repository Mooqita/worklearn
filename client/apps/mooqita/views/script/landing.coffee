#########################################################
# Landing
#########################################################

#########################################################
Template.mooqita_landing.onCreated ->
	self = this

	self.autorun () ->
		filter =
			group_name: "frontpage"
		self.subscribe "responses", filter, false, false, "mooqita_landing"

#########################################################
Template.mooqita_landing.onRendered ->
	try
		Fingerprint2 = require("fingerprintjs2")

		new Fingerprint2().get (result, components) ->
			Meteor.call "log_user", result,
				(err, res) ->
					if err
						console.log ["error", err]

	catch error
		console.log error

#########################################################
Template.mooqita_landing.helpers
	groups: () ->
		filter=
			group_name: "frontpage"

		mod =
			sort:
				index: 1
				view_order: 1

		return Responses.find(filter, mod)

