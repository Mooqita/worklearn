###############################################
Meteor.methods
	add_review: () ->
		user = Meteor.user()

		if not user._id
			throw new Meteor.Error('Not permitted.')

		res = gen_review null, null, user
		return res


	add_review_for_challenge: (challenge_id) ->
		user = Meteor.user()
		challenge = secure_item_action  Challenges, challenge_id, false
		res = gen_review challenge, null, user
		return res


	add_tutor_review: (solution_id) ->
		user = Meteor.user()
		solution = secure_item_action  Solutions, solution_id, false

		if not Roles.userIsInRole user, "tutor"
			throw new Meteor.Error('Not permitted.')

		res = gen_review null, solution, user
		return res


	finish_review: (review_id) ->
		user = Meteor.user()
		review = secure_item_action Reviews, review_id, true
		review_id = finish_review review, user

		res =
			review_id: review._id
			solution_id: review.solution_id
			challenge_id: review.challenge_id

		return res


	finish_feedback: (feedback_id) ->
		user = Meteor.user()
		feedback = secure_item_action Feedback, feedback_id, true
		feedback_id = finish_feedback feedback, user

		res =
			review_id: feedback.review_id
			feedback_id: feedback_id
			solution_id: feedback.solution_id
			challenge_id: feedback.challenge_id

		return res
