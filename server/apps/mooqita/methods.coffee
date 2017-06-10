###############################################
Meteor.methods
	add_profile: (param) ->
		check param.occupation, String
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		profile = Profiles.findOne user._id

		if profile
			throw new Meteor.Error "Profile already created"

		return gen_profile user, param.occupation


	add_challenge: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		return gen_challenge user


	finish_challenge: (challenge_id) ->
		user = Meteor.user()
		challenge = secure_item_action Challenges, challenge_id, true
		return finish_challenge challenge, user


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

	###########################################################
	# admin stuff
	###########################################################

	###########################################################
	send_message_to_challenge_students: (challenge_id, subject, message) ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if !Roles.userIsInRole(user._id, 'admin')
			throw new Meteor.Error('Not permitted.')

		# we need to know who is registered for a course.
		users = Meteor.users.find()
		usrs = users.fetch()

		for u in usrs
			send_mail u, subject, message

		return users.count()
