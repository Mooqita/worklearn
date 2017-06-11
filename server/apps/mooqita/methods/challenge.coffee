###############################################
Meteor.methods
	add_challenge: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		return gen_challenge user

	finish_challenge: (challenge_id) ->
		user = Meteor.user()
		challenge = secure_item_action Challenges, challenge_id, true
		return finish_challenge challenge, user

	send_message_to_challenge_students: (challenge_id, subject, message) ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if !Roles.userIsInRole(user._id, 'admin')
			throw new Meteor.Error('Not permitted.')

		# we need to know who is registered for a course.
		filter =
			challenge_id: challenge_id

		solutions = Solutions.find filter

		solutions.forEach (solution) ->
			user = Meteor.users.findOne solution.owner_id
			send_mail user, subject, message

		return solutions.count()
