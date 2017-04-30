###############################################
@send_mail = (user_id, subject, text) ->
	filter =
		owner_id: user_id
		type_identifier: "profile"

	profile = Responses.findOne filter
	user = Meteor.users.findOne user_id

	if not user.emails
		throw new Meteor.Error "send_mail could not find an email address for user: " + user_id

	to = user.emails[0].address
	cc = "public.markus.krause@gmail.com"
	from = "noreply@mooqita.org"

	Meteor.defer () ->
		console.log "sending mail"
		Email.send {to, from, cc, subject, text}


###############################################
@gen_message = (user_id, title, message, url) ->
	#save message
	msg =
		type_identifier: "message"
		owner_id: user_id
		content: message
		title: title
		seen: false
		url: url

	m_id = save_document Responses, msg

	# handle notifications
	p_filter =
		owner_id: user_id
		type_identifier: "profile"

	profile = Responses.findOne p_filter

	#cycle = profile.notification_cycle
	#last = profile.last_notification
	#now = new Date()
	#dif = now - last

	#if cycle > dif
	#	return

	if profile.mail_notifications == "yes"
		send_mail user_id, title, message

	return m_id


###############################################
@finish_message = (message_id) ->
	return modify_field_unprotected "Responses", message_id, "seen", true


###############################################
@send_review_message = (review) ->
	challenge = Responses.findOne review.challenge_id
	solution = Responses.findOne review.solution_id

	filter =
		owner_id: solution.owner_id
		type_identifier: "profile"
	solution_profile = Responses.findOne filter

	subject = "Mooqita: You got a new review"
	url = Meteor.absoluteUrl() + "user?template=student_solution&challenge_id=" + challenge._id

	body = "Hi " + solution_profile.given_name + ",\n\n"
	body += "You received a new review. \n"
	body += "To check it out, follow this link: " + url + "\n\n"
	body += "Kind regards, \n"
	body += " Your Mooqita Team \n\n"

	body += "You can disable mail notifications in your profile: " +
					Meteor.absoluteUrl() + "user?template=student_profile\n"

	gen_message solution.owner_id, subject, body, url

	return true

###############################################
@send_feedback_message = (feedback) ->
	challenge = Responses.findOne feedback.challenge_id
	review = Responses.findOne feedback.parent_id

	filter =
		owner_id: review.owner_id
		type_identifier: "profile"
	review_profile = Responses.findOne filter

	subject = "Mooqita: New feedback for your reviews"
	url = Meteor.absoluteUrl() + "user?template=student_solution&challenge_id=" + challenge._id

	body = "Hi " + review_profile.given_name + ",\n\n"
	body += "You received feedback to one of your reviews. \n"
	body += "To check it out, follow this link: " + url + "\n\n"
	body += "Kind regards, \n"
	body += " Your Mooqita Team \n\n"

	body += "You can disable mail notifications in your profile: "+
					Meteor.absoluteUrl() + "user?template=student_profile\n"

	gen_message review.owner_id, subject, body, url

	return true