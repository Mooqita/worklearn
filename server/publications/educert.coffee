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
	filter = filter_visible_documents user_id, {owner_id: user_id}

	crs = find_documents_paged_unprotected EduCertTemplate, filter,
			_cert_template_fields, parameter

	log_publication "EduCertTemplate", crs, filter,
			_cert_template_fields, "my_cert_templates", user_id
	return crs


#######################################################
Meteor.publish "my_cert_template_by_id", (cert_id) ->
	check cert_id, String

	user_id = this.userId

	restrict =
		_id:cert_id
		owner_id: user_id

	filter = filter_visible_documents user_id, restrict
	crs = EduCertTemplate.find filter, _cert_template_fields

	log_publication "EduCertTemplate", crs, filter,
			_cert_template_fields, "my_cert_template_by_id", user_id
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
	filter = filter_visible_documents user_id, {owner_id: user_id}

	crs = find_documents_paged_unprotected EduCertRecipients, filter,
			_cert_recipient_fields, parameter

	log_publication "EduCertRecipients", crs, filter,
			_cert_recipient_fields, "my_recipients", user_id
	return crs


#######################################################
Meteor.publish "recipient_by_id", (recipient_id) ->
	user_id = this.userId

	crs = EduCertRecipients.find recipient_id

	log_publication "EduCertRecipients", crs, {_id:recipient_id},
			_cert_recipient_fields, "recipient_by_id", user_id
	return crs


#######################################################
Meteor.publish "assertion_by_recipient_id", (recipient_id) ->
	user_id = this.userId

	recipient = find_document EduCertRecipients, recipient_id, false
	crs = find_cert_assertions recipient

	log_publication "EduCertAssertions", crs, {_id:recipient_id},
			_cert_assertion_fields, "assertion_by_recipient_id", user_id
	return crs


#######################################################
Meteor.publish "assertion_by_id", (assertion_id) ->
	user_id = this.userId

	crs = EduCertAssertions.find assertion_id

	log_publication "EduCertAssertions", crs, {_id:assertion_id},
			_cert_assertion_fields, "assertion_by_id", user_id
	return crs


