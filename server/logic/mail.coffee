###############################################
@send_message_mail = (user, subject, body) ->
	msg = "@send_message_mail trying to send mail message"
	log_event msg, event_mail, event_info
	# handle notifications
	p_filter =
		owner_id: user._id

	profile = Profiles.findOne p_filter

	if not user.emails
		throw new Meteor.Error "send_mail could not find an email address for user: " + user._id

	to = user.emails[0].address

	if not profile
		send_mail to, subject, body
		return

	#cycle = profile.notification_cycle
	#last = profile.last_notification
	#now = new Date()
	#dif = now - last

	#if cycle > dif
	#	return

	if profile.mail_notifications == "yes"
		send_mail to, subject, body


###############################################
@send_mail = (to, subject, text) ->
	from = "no-reply@mooqita.org"

	Meteor.defer () ->
		log_event "Sending mail", event_mail, event_info #TODO: stack trace
		try
			Email.send {to, from, subject, text}
			log_event "Mail send", event_mail, event_info #TODO: stack trace

		catch error
			log_event error, event_mail, event_err #TODO: stack trace



