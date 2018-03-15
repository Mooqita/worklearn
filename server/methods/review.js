Meteor.methods({
	assign_review: () => {
		var user = Meteor.user()

		if(!user._id) {
        	throw new Meteor.Error('Not permitted.')
        }

		var res = assign_review(null, null, user)
		return res
    },

	assign_review_with_challenge: (challenge_id) => {
		var user = Meteor.user()
		var challenge = find_document(Challenges, challenge_id, false)
		var res = assign_review(challenge, null, user)
		return res
    },

	assign_review_to_tutor: (solution_id) => {
		var user = Meteor.user()
		var solution = find_document(Solutions, solution_id, false)

		if(!Roles.userIsInRole(user, 'tutor')) {
			throw new Meteor.Error('Not permitted.')
        }

		var res = find_review(null, solution, user)
		return res
    },

	finish_review: (review_id) => {
		var user = Meteor.user()
		var review = find_document(Reviews, review_id, true)
		var review_id = finish_review(review, user)

		var res = {
			review_id: review._id,
			solution_id: review.solution_id,
			challenge_id: review.challenge_id
        }

		return res
    }
})
