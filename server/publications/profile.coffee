#######################################################
#
# Created by Markus.
#
#######################################################

#######################################################
Meteor.publish "my_profile", () ->
	user_id = this.userId
	filter =
		owner_id: user_id

	fields = visible_fields Profiles, user_id, filter
	crs = Profiles.find filter, fields

	log_publication "Profile", crs, filter, {}, "profiles", user_id
	return crs

