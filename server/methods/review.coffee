################################################################
#
# Markus 1/23/2017
#
################################################################

###############################################
Meteor.methods
	assign_review: () ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error('Not permitted.')

		res = assign_review null, user
		return res


	assign_review_with_challenge: (challenge_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error('Not permitted.')

		challenge = get_document_unprotected  Challenges, challenge_id
		res = assign_review challenge, user
		return res


	assign_review_to_tutor: (solution_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error('Not permitted.')

		solution = get_document_unprotected Solutions, solution_id

		if not has_role Challenges, solution.challenge_id, user, TUTOR
			throw new Meteor.Error('Not permitted.')

		res = get_open_review_for_solution solution
		return res


	finish_review: (review_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error('Not permitted.')

		if not can_edit Reviews, review_id, user
			throw new Meteor.Error('Not permitted.')

		review = get_document_unprotected Reviews, review_id
		review_id = finish_review review, user

		res =
			review_id: review._id
			solution_id: review.solution_id
			challenge_id: review.challenge_id

		return res
