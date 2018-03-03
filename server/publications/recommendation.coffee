#######################################################
Meteor.publish "my_recommendation_by_recipient_id", (recipient_id) ->
	check recipient_id, String

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter =
		recipient_id: recipient_id

	crs = get_my_documents Recommendations, filter, {}

	log_publication crs, user_id, "recommendations"
	return crs


#######################################################
Meteor.publish "recommendation_for_me", () ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter =
		recipient_id: user_id

	crs = get_documents IGNORE, IGNORE, Recommendations, filter, {}

	log_publication crs, user_id, "recommendations"
	return crs

