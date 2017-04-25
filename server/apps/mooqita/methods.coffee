###############################################
Meteor.methods
	add_profile: (param) ->
		check param.occupation, String

		user_id = Meteor.userId()

		filter =
			owner_id: user_id
			type_identifier: "profile"

		profile = Responses.findOne filter

		if profile
			throw new Meteor.Error "Profile already created"

		return gen_profile user_id, param.occupation


	add_challenge: () ->
		user_id = Meteor.userId()
		return gen_challenge user_id

	finish_challenge: (challenge_id) ->
		check challenge_id, String
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		challenge = Responses.findOne challenge_id
		if not challenge
			throw new Meteor.Error('Not permitted.')

		if challenge.owner_id != user._id
			throw new Meteor.Error('Not permitted.')

		return finish_challenge(challenge_id)


	add_solution: (challenge_id) ->
		check challenge_id, String
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		challenge = Responses.findOne challenge_id
		if not challenge
			throw new Meteor.Error('Not permitted.')

		return gen_solution challenge, Meteor.userId()


	request_review: (solution_id) ->
		check solution_id, String
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		solution = Responses.findOne solution_id

		if not solution.owner_id == user._id
			throw new Meteor.Error('Not permitted.')

		return request_review solution, user._id


	find_review: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		filter =
			owner_id: user._id
			type_identifier: "profile"
		profile = Responses.findOne filter

		chl_sol = find_solution_to_review user._id
		rev_fed = gen_review chl_sol.challenge, chl_sol.solution, user._id

		return rev_fed.review_id


	find_review_for_challenge: (challenge_id) ->
		check challenge_id, String

		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		filter =
			owner_id: Meteor.userId()
			type_identifier: "profile"
		profile = Responses.findOne filter

		chl_sol = find_solution_to_review user._id, challenge_id
		rev_fed = gen_review chl_sol.challenge, chl_sol.solution, user._id

		return rev_fed.review_id

	finish_review: (review_id) ->
		review = Responses.findOne review_id
		return finish_review review, Meteor.userId()


	add_upwork_challenge: (response) ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if !Roles.userIsInRole(user._id, 'db_admin')
			throw new Meteor.Error('Not permitted.')

		response.visible_to = "owner"
		response.owner_id = Meteor.userId()

		Responses.insert response

