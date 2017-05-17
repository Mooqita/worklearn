###############################################
@send_message_mail = (user_id, subject, body) ->
	# handle notifications
	p_filter =
		owner_id: user_id

	profile = Profiles.findOne p_filter

	#cycle = profile.notification_cycle
	#last = profile.last_notification
	#now = new Date()
	#dif = now - last

	#if cycle > dif
	#	return

	if profile.mail_notifications == "yes"
		send_mail user_id, subject, body

###############################################
@send_mail = (user_id, subject, text) ->
	user = Meteor.users.findOne user_id

	if not user.emails
		throw new Meteor.Error "send_mail could not find an email address for user: " + user_id

	to = user.emails[0].address
	cc = "public.markus.krause@gmail.com"
	from = "noreply@mooqita.org"

	Meteor.defer () ->
		log_event "Sending mail", event_mail, event_info #TODO: stack trace
		try
			Email.send {to, from, cc, subject, text}
		catch error
			log_event error, event_mail, event_err #TODO: stack trace



