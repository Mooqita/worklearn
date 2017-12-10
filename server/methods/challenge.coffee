################################################################
#
# Markus 1/23/2017
#
################################################################

###############################################
Meteor.methods
	add_challenge: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		return gen_challenge user

	finish_challenge: (challenge_id) ->
		user = Meteor.user()
		challenge = find_document Challenges, challenge_id, true
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
			name = get_profile_name_by_user_id user._id, true, false
			subject =	subject.replace("<<name>>", name)
			message =	message.replace("<<name>>", name)
			send_mail user, subject, message

		return solutions.count()
