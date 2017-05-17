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
		return gen_solution challenge, Meteor.userId()


	finish_solution: (solution_id) ->
		check solution_id, String
		solution = secure_item_action Solutions, solution_id, true
		return finish_solution solution, Meteor.userId()


	add_review: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		return gen_review user._id


	finish_review: (review_id) ->
		review = secure_item_action Reviews, review_id, true
		r_id = finish_review review, Meteor.userId()

		return r_id


	finish_feedback: (feedback_id) ->
		feedback = secure_item_action Feedback, feedback_id, true
		return finish_feedback feedback, Meteor.userId()

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

			when "got_review"
				filter =
					owner_id: Meteor.userId()

				solution = Solutions.findOne filter
				challenge = Challenges.findOne solution.challenge_id
				rev_id = gen_review challenge, solution, Meteor.userId()

				modify_field_unprotected Reviews, rev_id.review_id, "rating", 3
				review = Reviews.findOne rev_id.review_id

				finish_review review, Meteor.userId()

				msg = "message : " + type + " send."
				log_event msg, event_create, event_info

			else
				msg = "message type: " + type + " unknown."
				log_event msg, event_create, event_err
