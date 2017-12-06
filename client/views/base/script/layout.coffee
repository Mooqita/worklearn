################################################
#
# Entry point for all templates
#
################################################

################################################
Template.pre_loader.onCreated ->
	self = this

	Meteor.call "log_user",
		(err, res) ->
			if err
				console.log ["error", err]

	self.autorun ->
		Meteor.subscribe "my_profile",
			(err, res) ->
				if err
					sAlert.error "Profile subscription error: " + err
					console.log err
