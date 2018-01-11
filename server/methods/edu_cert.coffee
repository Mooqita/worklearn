################################################################
#
# Markus 1/23/2017
#
################################################################

###############################################
Meteor.methods
	add_cert_template: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		return gen_cert_template user


	add_recipients: (cert_template_id, recipients) ->
		check recipients, String
		check cert_template_id, String

		user = Meteor.user()
		if not user
			throw new Meteor.Error('Not permitted.')

		cert_template = get_my_document EduCertTemplate, cert_template_id

		for r in recipients.split ","
			gen_cert_recipient(user, cert_template, r)

		return true


	bake_cert: (recipient_id) ->
		user = Meteor.user()
		recipient = get_my_document EduCertRecipients, recipient_id
		return gen_cert_assertion recipient, user

