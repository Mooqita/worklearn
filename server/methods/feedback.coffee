###############################################
Meteor.methods
	repair_feedback: (review_id) ->
		user = Meteor.user()
		review = find_document Reviews, review_id, false
		solution = find_document Solutions, review.solution_id, true

		return repair_feedback solution, review, user


	finish_feedback: (feedback_id) ->
		user = Meteor.user()
		feedback = find_document Feedback, feedback_id, true
		feedback_id = finish_feedback feedback, user

		res =
			review_id: feedback.review_id
			feedback_id: feedback_id
			solution_id: feedback.solution_id
			challenge_id: feedback.challenge_id

		return res
