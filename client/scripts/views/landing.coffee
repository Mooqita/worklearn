#########################################################
# Landing
#########################################################

#########################################################
Template.landing.onCreated ->
	self = this

	self.autorun () ->
		self.subscribe 'responses_with_data', 'frontpage'

Template.landing.onRendered ->
	Fingerprint2 = require('fingerprintjs2')

	new Fingerprint2().get (result) ->
		Meteor.call "log_user", result

Template.landing.helpers
	groups: () ->
		filter=
			post_group:'frontpage'
			parent_id: ''

		mod =
			sort:
				index:1
				view_order:1

		return Responses.find(filter, mod)
