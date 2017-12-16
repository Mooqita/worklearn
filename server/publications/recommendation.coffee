#######################################################
Meteor.publish "my_recommendations", () ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter =
		owner_id: user_id

	fields = get_visible_fields Recommendations, user_id, filter
	crs = Recommendations.find filter, fields

	log_publication "Recommendations", crs, filter, {}, "recommendations", user_id
	return crs


#######################################################
Meteor.publish "my_recommendation_by_recipient_id", (recipient_id) ->
	check recipient_id, String

	user_id = this.userId
	filter =
		owner_id: user_id
		recipient_id: recipient_id

	fields = get_visible_fields Recommendations, user_id, filter
	crs = Recommendations.find filter, fields

	log_publication "Recommendations", crs, filter, {}, "recommendations", user_id
	return crs


#######################################################
Meteor.publish "recommendation_for_me", () ->
	user_id = this.userId
	filter =
		recipient_id: user_id

	fields = get_visible_fields Recommendations, user_id, filter
	crs = Recommendations.find filter, fields

	log_publication "Recommendations", crs, filter, {}, "recommendations", user_id
	return crs

