#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
# item header
#######################################################

#######################################################
_review_fields =
	fields:
		rating: 1
		content: 1
		published: 1
		parent_id: 1
		solution_id: 1
		challenge_id: 1

#######################################################
# reviews
#######################################################

#######################################################
Meteor.publish "my_reviews", () ->
	user_id = this.userId
	restrict =
		owner_id: user_id

	filter = visible_items user_id, restrict
	crs = Reviews.find filter, _review_fields

	log_publication "Reviews", crs, filter,
			_review_fields, "my_reviews", user_id
	return crs


#######################################################
Meteor.publish "my_review_by_id", (review_id) ->
	check review_id, String
	user_id = this.userId

	restrict =
		_id: review_id
		owner_id: user_id

	filter = visible_items user_id, restrict
	crs = Reviews.find filter, _review_fields

	log_publication "Reviews", crs, filter,
			_review_fields, "my_review_by_id", user_id
	return crs


#######################################################
Meteor.publish "reviews_by_solution_id", (solution_id) ->
	check solution_id, String
	user_id = this.userId

	filter =
		solution_id: solution_id
		published: true

	crs = Reviews.find filter, _review_fields

	log_publication "Reviews", crs, filter,
			_review_fields, "reviews_by_solution_id", user_id
	return crs

