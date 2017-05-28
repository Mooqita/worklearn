###############################################
Meteor.methods
	add_profile: (param) ->
		check param.occupation, String
		user_id = Meteor.userId()

		if not user_id
			throw new Meteor.Error('Not permitted.')

		profile = Profiles.findOne user_id

		if profile
			throw new Meteor.Error "Profile already created"

		return gen_profile user_id, param.occupation


	add_challenge: () ->
		user_id = Meteor.userId()

		if not user_id
			throw new Meteor.Error('Not permitted.')

		return gen_challenge user_id


	finish_challenge: (challenge_id) ->
		check challenge_id, String
		challenge = secure_item_action Challenges, challenge_id, true
		return finish_challenge challenge


	add_solution: (challenge_id) ->
		check challenge_id, String
		challenge = secure_item_action Challenges, challenge_id, false
		solution_id = gen_solution challenge, Meteor.userId()
		res =
			solution_id: solution_id
			challenge_id: challenge_id
		return res

	finish_solution: (solution_id) ->
		check solution_id, String
		solution = secure_item_action Solutions, solution_id, true
		solution_id = finish_solution solution, Meteor.userId()
		res =
			solution_id: solution_id
			challenge_id: solution.challenge_id
		return res


	add_review: () ->
		user_id = Meteor.userId()

		if not user_id
			throw new Meteor.Error('Not permitted.')

		res = gen_review null, null, user_id
		return res


	add_review_for_challenge: (challenge_id) ->
		check challenge_id, String
		user_id = Meteor.userId()

		if not user_id
			throw new Meteor.Error('Not permitted.')

		res = gen_review challenge_id, null, user_id
		return res

	add_tutor_review: (solution_id) ->
		check solution_id, String
		user_id = Meteor.userId()

		if not user_id
			throw new Meteor.Error('Not permitted.')

		filter =
			owner_id: user_id

		mod =
			fields:
				tutor: 1

		profile = Profiles.findOne filter, mod
		if not profile.tutor
			throw new Meteor.Error('Not permitted.')

		res = gen_review null, solution_id, user_id
		return res


	finish_review: (review_id) ->
		review = secure_item_action Reviews, review_id, true
		review_id = finish_review review, Meteor.userId()

		res =
			review_id: review._id
			solution_id: review.solution_id
			challenge_id: review.challenge_id

		return res


	finish_feedback: (feedback_id) ->
		feedback = secure_item_action Feedback, feedback_id, true
		feedback_id = finish_feedback feedback, Meteor.userId()

		res =
			review_id: feedback.review_id
			feedback_id: feedback_id
			solution_id: feedback.solution_id
			challenge_id: feedback.challenge_id

		return res

	###########################################################
	# admin stuff
	###########################################################

	###########################################################
	send_test_message: (type) ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if !Roles.userIsInRole(user._id, 'db_admin')
			throw new Meteor.Error('Not permitted.')

		switch type
			when "send_mail"
				send_mail Meteor.userId(), "subject", "message"
			else
				msg = "message type: " + type + " unknown."
				log_event msg, event_create, event_err
