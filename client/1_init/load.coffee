###############################################################################
#
# Autorun subscriptions
#
################################################################################

################################################################################
Meteor.startup ()->
	Tracker.autorun ()->
		Meteor.subscribe "my_profile",
			(err, res) ->
				if err
					sAlert.error "Profile subscription error: " + err
					console.log err

	Tracker.autorun () ->
		# TODO: might get slow for n > X000 (150 Byte each.)
		# this can happen if the user has a very large number
		# of admissions. Not very likely at the moment though.
		Meteor.subscribe "my_admissions",
			(err, res) ->
				if err
					sAlert.error "Admissions subscription error: " + err
					console.log err