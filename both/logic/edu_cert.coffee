###############################################
@find_cert_recipient = (cert_template_id, recipient_mail) ->
	recipient_mail = recipient_mail.split("\n")[0]
	recipient_mail = recipient_mail.split("\r")[0]

	filter =
		"cert_template_id": cert_template_id
		"email": recipient_mail

	recipients = EduCertRecipients.find(filter)
	return recipients


###############################################
@find_cert_assertions = (recipient) ->
	recipient_mail = recipient.email
	recipient_mail = recipient_mail.split("\n")[0]
	recipient_mail = recipient_mail.split("\r")[0]

	filter =
		"payload.badge.id": recipient.cert_template_id
		"payload.recipient.identity": recipient_mail

	assertions = EduCertAssertions.find(filter)
	return assertions

