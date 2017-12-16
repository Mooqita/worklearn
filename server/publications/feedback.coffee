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
		published: 1
		review_id: 1
		solution_id: 1
		challenge_id: 1

#######################################################
Meteor.publish "my_feedback", () ->
	user_id = this.userId
	crs = get_my_documents "feedback", {}, _feedback_fields

	log_publication crs, user_id, "my_feedback"
	return crs

#######################################################
Meteor.publish "my_feedback_by_challenge_id", (challenge_id) ->
	check challenge_id, String
	user_id = this.userId

	filter = {challenge_id: challenge_id}
	crs = get_my_documents "feedback", filter, _feedback_fields

	log_publication crs, user_id, "my_feedback_by_challenge_id"
	return crs

#######################################################
Meteor.publish "my_feedback_by_solution_id", (solution_id) ->
	check solution_id, String
	user_id = this.userId

	crs = get_my_documents "feedback", {solution_id: solution_id}, _feedback_fields

	log_publication crs, user_id, "my_feedback_by_solution_id"
	return crs


#######################################################
Meteor.publish "my_feedback_by_review_id", (review_id) ->
	check review_id, String
	user_id = this.userId

	crs = get_my_documents "feedback", {review_id: review_id}, _feedback_fields

	log_publication crs, user_id, "my_feedback_by_review_id"
	return crs


#######################################################
Meteor.publish "feedback_by_review_id", (review_id) ->
	check review_id, String
	user_id = this.userId

	filter =
		review_id: review_id
	crs = Feedback.find filter, _feedback_fields

	log_publication crs, user_id, "feedback_by_review_id"
	return crs
