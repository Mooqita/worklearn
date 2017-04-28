###############################################
Meteor.methods
	add_profile: (param) ->
		check param.occupation, String
		user_id = Meteor.userId()

		if not user_id
			throw new Meteor.Error('Not permitted.')

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
		challenge = secure_item_action challenge_id, "challenge", true
		return finish_challenge challenge


	add_solution: (challenge_id) ->
		check challenge_id, String
		challenge = secure_item_action challenge_id, "challenge", false
		return gen_solution challenge, Meteor.userId()


	request_review: (solution_id) ->
		check solution_id, String
		solution = secure_item_action solution_id, "solution", true
		return request_review solution, Meteor.userId()


	provide_review: () ->
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

