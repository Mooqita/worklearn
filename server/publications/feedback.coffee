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
_feedback_fields =
	fields:
		rating: 1
		content: 1
		owner_id: 1
		parent_id: 1
		published: 1
		solution_id: 1
		challenge_id: 1

#######################################################
Meteor.publish "my_feedback", () ->
	user_id = this.userId

	filter =
		owner_id: user_id
	crs = Feedback.find filter, _feedback_fields

	log_publication "Feedback", crs, filter,
			_feedback_fields, "my_feedback", user_id
	return crs

#######################################################
Meteor.publish "my_feedback_by_challenge_id", (challenge_id) ->
	check challenge_id, String
	user_id = this.userId

	filter =
		challenge_id: challenge_id
		owner_id: user_id
	crs = Feedback.find filter, _feedback_fields

	log_publication "Feedback", crs, filter,
			_feedback_fields, "my_feedback_by_challenge_id", user_id
	return crs

#######################################################
Meteor.publish "my_feedback_by_solution_id", (solution_id) ->
	check solution_id, String
	user_id = this.userId

	filter =
		solution_id: solution_id
		owner_id: user_id
	crs = Feedback.find filter, _feedback_fields

	log_publication "Feedback", crs, filter,
			_feedback_fields, "my_feedback_by_solution_id", user_id
	return crs


#######################################################
Meteor.publish "my_feedback_by_review_id", (review_id) ->
	check review_id, String
	user_id = this.userId

	filter =
		parent_id: review_id
		owner_id: user_id
	crs = Feedback.find filter, _feedback_fields

	log_publication "Feedback", crs, filter,
			_feedback_fields, "my_feedback_by_review_id", user_id
	return crs


#######################################################
Meteor.publish "feedback_by_review_id", (review_id) ->
	check review_id, String
	user_id = this.userId

	filter =
		review_id: review_id
	crs = Feedback.find filter, _feedback_fields

	log_publication "Feedback", crs, _feedback_fields,
			_feedback_fields, "feedback_by_review_id", user_id
	return crs
