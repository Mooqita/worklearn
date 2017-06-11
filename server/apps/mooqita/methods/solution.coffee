###############################################
Meteor.methods
	add_solution: (challenge_id) ->
		user = Meteor.user()
		challenge = secure_item_action Challenges, challenge_id, false
		solution_id = gen_solution challenge, user
		res =
			solution_id: solution_id
			challenge_id: challenge_id
		return res

	finish_solution: (solution_id) ->
		user = Meteor.user()
		solution = secure_item_action Solutions, solution_id, true
		solution_id = finish_solution solution, user
		res =
			solution_id: solution_id
			challenge_id: solution.challenge_id
		return res

	reopen_solution: (solution_id) ->
		user = Meteor.user()
		solution = secure_item_action  Solutions, solution_id, false

		if not Roles.userIsInRole user, "admin"
			throw new Meteor.Error('Not permitted.')

		res = reopen_solution solution, user
		return res
