###############################################################################
#
# Markus 1/23/2017
#
###############################################################################

###############################################################################
Meteor.methods
	add_answer_only_solution: (name, email, solution, challenge_id) ->
		check name, String
		check email, String
		check solution, String
		check challenge_id, String

		challenge = Challenges.findOne(challenge_id)
		if not challenge
			throw new Meteor.Error("Not authorized")

		if not challenge.published
			throw new Meteor.Error("Not authorized")

		solution =
			name: "Solution: " + challenge.title
			challenge_id: challenge._id
			published: true
			owner_name: name
			owner_email: email
			content: solution

		solution_id = Solutions.insert(solution)

		return solution_id



	add_solution: (challenge_id, company_tag) ->
		check company_tag, Match.Maybe(String)

		user = Meteor.user()
		if not user._id
			throw new Meteor.Error('Not permitted.')

		challenge = get_document_unprotected Challenges, challenge_id
		solution_id = gen_solution challenge, user, company_tag
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
