###############################################
#
###############################################

###############################################
Meteor.methods
	repair_feedback: (review_id) ->
		user = Meteor.user()
		if not can_edit Reviews, review_id, user
			throw new Meteor.Error 'Not permitted.'

		review = get_document_unprotected Reviews, review_id
		solution = get_document_unprotected Solutions, review.solution_id

		return repair_feedback solution, review, user


	finish_feedback: (feedback_id) ->
		user = Meteor.user()
		if not can_edit Feedback, feedback_id, user
			throw new Meteor.Error 'Not permitted.'

		feedback = get_document_unprotected Feedback, feedback_id
		feedback_id = finish_feedback feedback, user

		res =
			review_id: feedback.review_id
			feedback_id: feedback_id
			solution_id: feedback.solution_id
			challenge_id: feedback.challenge_id

		return res
