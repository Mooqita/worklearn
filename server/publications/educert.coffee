#######################################################
#
#	Mooqita collections
# Created by Markus on 26/10/2017.
#
#######################################################

#######################################################
# item header
#######################################################

#######################################################
_cert_template_fields =
	id: 1
	type	: 1
	name	: 1
	description: 1
	image: 1
	criteria: 1
	issuer: 1
	alignment: 1
	tags: 1

#######################################################
_cert_assertion_fields =
	type: 1
	id: 1
	issuedOn: 1
	"@context": 1
	badge: 1
	recipient: 1
	recipientProfile: 1
	verification: 1

#######################################################
_cert_recipient_fields =
	id: 1
	email: 1
	display_name: 1
	block_profile_public_key: 1

#######################################################
# Templates
#######################################################

#######################################################
Meteor.publish "my_cert_templates", (parameter) ->
	pattern =
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
	filter = get_my_filter EduCertTemplate, {}

	crs = get_documents_paged_unprotected EduCertTemplate, filter,
			_cert_template_fields, parameter

	log_publication "EduCertTemplate", crs, filter,
			_cert_template_fields, "my_cert_templates", user_id
	return crs


#######################################################
Meteor.publish "my_cert_template_by_id", (cert_id) ->
	check cert_id, String

	user_id = this.userId
	filter = {_id: cert_id}
	crs = get_my_documents EduCertTemplate, filter, _cert_template_fields

	log_publication crs, user_id, "my_cert_template_by_id"
	return crs

#######################################################
# Recipients
#######################################################

#######################################################
Meteor.publish "my_recipients", (parameter) ->
	pattern =
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
	filter = get_my_filter EduCertRecipients, {}
	crs = get_documents_paged_unprotected EduCertRecipients, filter,
			_cert_recipient_fields, parameter

	log_publication crs, user_id, "my_recipients"
	return crs


#######################################################
Meteor.publish "recipient_by_id", (recipient_id) ->
	user_id = this.userId
	crs = EduCertRecipients.find recipient_id

	log_publication crs, user_id, "recipient_by_id"
	return crs


#######################################################
Meteor.publish "assertion_by_recipient_id", (recipient_id) ->
	user = Meteor.user()
	if not can_edit EduCertRecipients, recipient_id, user
		throw new Meteor.Error('Not permitted.')

	recipient = get_document_unprotected EduCertRecipients, recipient_id
	crs = find_cert_assertions recipient

	log_publication crs, user, "assertion_by_recipient_id"
	return crs


#######################################################
Meteor.publish "assertion_by_id", (assertion_id) ->
	user = Meteor.user()
	crs = EduCertAssertions.find assertion_id

	log_publication crs, user, "assertion_by_id"
	return crs


