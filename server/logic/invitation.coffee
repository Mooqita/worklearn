################################################################
@gen_invitation = (organization_id, email, host_id, host_name) ->
		filter =
			organization_id: organization_id
			email: email

		crs = Invitations.findOne filter
		if crs
			return crs._id

		filter["host_name"] = host_name
		filter["host_id"] = host_id

		invitation_id = store_document_unprotected Invitations, filter, host_id, true
		user = Accounts.findUserByEmail(email)
		base = if user then "app" else "onboarding"

		param =
			invitation_id: invitation_id
			organization_id: organization_id
		url = build_url "invitation", param, base, true

		subject = "Mooqita: Invitation from " + host_name

		body = "Hi, \n"
		body += host_name + " has send you an invitation to join Mooqita. \n"
		body += "Please follow this link: " + url + " to check out the invitation.\n"
		body += "You can chose on the website if you want to join or not.\n\n"
		body += "Kind regards,\n Your Mooqita Team"

		send_mail email, subject, body


################################################################
@accept_invitation = (invitation_id) ->
	invitation = Invitations.findOne invitation_id
	if not invitation
		throw new Meteor.error "Invitation not found."

	organization = Organizations.findOne invitation.organization_id
	host_id = invitation.host_id

	if not is_owner Organizations, organization._id, host_id
		throw new Meteor.Error "The host is not authorized to invite members."

	email = invitation.email
	invitee = Accounts.findUserByEmail email

	if not invitee
		throw new Meteor.error "Invitee email address does not have an associated account."

	admission_id = gen_admission Organizations, organization, invitee, "employee"
	modify_field_unprotected Invitations, invitation._id, "accepted", true

	return admission_id

