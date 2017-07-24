##############################################
@get_profile = (user_id) ->
	if not user_id
		user_id = Meteor.userId()

	filter =
		owner_id: user_id
	profile = Profiles.findOne filter

	return profile
