###############################################################################
#
# Loading and caching subscriptions
#
###############################################################################

################################################################################
# make active admission sets
################################################################################

################################################################################
_key_from_collection_name = (name) ->
	key = "active_" + name + "_admissions"
	return key

################################################################################
_subscription_from_collection_name = (name) ->
	subscription_name = name + "_by_admissions"
	return subscription_name

################################################################################
_make_admission_set = (collection)->
	name = get_collection_name(collection)
	key = _key_from_collection_name(name)
	subscription_name = _subscription_from_collection_name(name)

	Session.set key, []

	Tracker.autorun () ->
		admissions = Session.get key
		Meteor.subscribe subscription_name, admissions


################################################################################
# add and remove active elements
################################################################################

################################################################################
@activate_admission = (admission) ->
	if not admission
		return

	name = admission.c
	key = _key_from_collection_name(name)

	values = Session.get(key)
	values.push(admission)
	values = values.unique()

	Session.set(key, values)


###############################################################################
# Autorun subscriptions
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

###############################################################################
# Session variables for the most important collections
################################################################################

################################################################################
Meteor.startup ()->
	_make_admission_set(Jobs)
	_make_admission_set(Challenges)
	_make_admission_set(Organizations)

###############################################################################
# Autorun subscriptions
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