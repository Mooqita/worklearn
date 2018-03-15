// Server Methods For The Feedback Collection

Meteor.methods({
	repair_feedback: (review_id) => {
		user = Meteor.user()
		review = find_document(Reviews, review_id, false)
		solution = find_document(Solutions, review.solution_id, true)

		return repair_feedback(solution, review, user)
    },

	finish_feedback: (feedback_id) => {
		var user = Meteor.user()
		var feedback = find_document(Feedback, feedback_id, true)
		var feedback_id = finish_feedback(feedback, user)

		var res = {
			review_id: feedback.review_id,
			feedback_id: feedback_id,
			solution_id: feedback.solution_id,
			challenge_id: feedback.challenge_id
        }

		return res
    }
})
