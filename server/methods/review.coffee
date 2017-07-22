###############################################
Meteor.methods
	find_review: () ->
		user = Meteor.user()

		if not user._id
			throw new Meteor.Error('Not permitted.')

		res = find_review null, null, user
		return res


	find_review_for_challenge: (challenge_id) ->
		user = Meteor.user()
		challenge = find_document  Challenges, challenge_id, false
		res = find_review challenge, null, user
		return res


	get_review_for_tutor: (solution_id) ->
		user = Meteor.user()
		solution = find_document  Solutions, solution_id, false

		if not Roles.userIsInRole user, "tutor"
			throw new Meteor.Error('Not permitted.')

		res = find_review null, solution, user
		return res


	finish_review: (review_id) ->
		user = Meteor.user()
		review = find_document Reviews, review_id, true
		review_id = finish_review review, user

		res =
			review_id: review._id
			solution_id: review.solution_id
			challenge_id: review.challenge_id

		return res
