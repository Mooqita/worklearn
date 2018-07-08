################################################################
#
# Markus 1/23/2017
#
################################################################

###############################################
Meteor.methods
	request_challenge: (challenge_id) ->
		check(challenge_id, String)
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		challenge_owner_id = get_document_owner(Challenges, challenge_id)
		if not (challenge_owner_id == user._id)
			throw new Meteor.Error('Not permitted.')

		url = build_url("challenge_design", {challenge_id: challenge_id}, "app", true)
		mail = get_user_mail(user)
		name = get_profile_name_by_user(user)
		subject = "Challenge design request" + challenge_id

		body = ""

		send_mail("markus@mooqita.com", subject, url)

		modify_field_unprotected(Challenges, challenge_id, "requested", true, user)

		return true


	add_challenge: (job_id) ->
		check(job_id, Match.Optional(String))
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		return gen_challenge user, job_id


	add_challenge_from_data: (data) ->
		check(data, Match.Optional(match_obj))
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		return gen_challenge_from_data user, data


	make_challenge: (title, content, link, origin, job_id) ->
		check(link, String)
		check(title, String)
		check(origin, String)
		check(content, String)
		check(job_id, Match.Maybe(String))

		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		return bake_challenge user, title, content, link, origin, job_id


	finish_challenge: (challenge_id) ->
		user = Meteor.user()
		if not can_edit Challenges, challenge_id, user
			throw new Meteor.Error("Not permitted.")

		item = get_document_unprotected Challenges, challenge_id
		return finish_challenge item, user

	send_message_to_challenge_learners: (challenge_id, subject, message) ->
		#TODO: move to logic

		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if not has_permission Challenges, challenge_id, user, SEND_MAIL
			throw new Meteor.Error('Not permitted.')

		# we need to know who is registered for a course.
		filter =
			challenge_id: challenge_id

		solutions = Solutions.find filter

		solutions.forEach (solution) ->
			owner_id = get_document_owner "solutions", solution
			name = get_profile_name_by_user owner_id, true, false
			subject =	subject.replace("<<name>>", name)
			message =	message.replace("<<name>>", name)
			send_mail user, subject, message

		return solutions.count()
