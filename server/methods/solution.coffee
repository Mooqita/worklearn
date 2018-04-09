################################################################
#
# Markus 1/23/2017
#
################################################################

###############################################
Meteor.methods
	add_solution: (challenge_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error('Not permitted.')

		challenge = get_document_unprotected Challenges, challenge_id
		solution_id = gen_solution challenge, user
		res =
			solution_id: solution_id
			challenge_id: challenge_id
		return res

	finish_solution: (solution_id) ->
		user = Meteor.user()
		if not can_edit Solutions, solution_id, user
			throw new Meteor.Error('Not permitted.')

		solution = get_document_unprotected Solutions, solution_id
		solution_id = finish_solution solution, user
		res =
			solution_id: solution_id
			challenge_id: solution.challenge_id
		return res

	reopen_solution: (solution_id) ->
		user = Meteor.user()
		solution = get_document_unprotected Solutions, solution_id

		if not can_edit Challenges, solution.challenge_id, user
			throw new Meteor.Error('Not permitted.')

		res = reopen_solution solution, user
		return res
