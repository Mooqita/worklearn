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
		parent_id: 1
		published: 1
		solution_id: 1
		challenge_id: 1

#######################################################
# feedback
#######################################################

#######################################################
Meteor.publish "my_feedback_by_review_id", (review_id) ->
	check review_id, String
	user_id = this.userId

	filter =
		parent_id: review_id
		owner_id: user_id
	crs = Feedback.find filter, _feedback_fields

	log_publication "Feedback", crs, filter,
			_challenge_fields, "my_feedback_by_review_id", user_id
	return crs


#######################################################
Meteor.publish "feedback_by_review_id", (review_id) ->
	check review_id, String
	user_id = this.userId

	filter =
		review_id: review_id
		provider_id: user_id

	request = ReviewRequests.findOne filter
	crs = Feedback.find request.feedback_id, _feedback_fields

	log_publication "Feedback", crs, filter,
			_challenge_fields, "feedback_by_review_id", user_id
	return crs
