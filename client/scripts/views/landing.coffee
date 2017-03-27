#########################################################
# Landing
#########################################################

#########################################################
Template.landing.onCreated ->
	self = this

	self.autorun () ->
		self.subscribe 'responses_by_group', 'frontpage', false

#########################################################
Template.landing.onRendered ->
	try
		Fingerprint2 = require('fingerprintjs2')

		new Fingerprint2().get (result, components) ->
			console.log "wrong?"
			Meteor.call "log_user", result,
				(err, res) ->
					if err
						console.log ["error", err]

	catch error
		console.log error

#########################################################
Template.landing.helpers
	groups: () ->
		filter=
			group_name:'frontpage'
			parent_id: ''

		mod =
			sort:
				index:1
				view_order:1

		return Responses.find(filter, mod)
