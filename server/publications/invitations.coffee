###############################################################################
_invitation_fields =
	fields:
		name: 1
		email: 1
		accepted: 1
		host_name: 1
		organization_id: 1

#######################################################
Meteor.publish "invitation_by_id", (invitation_id) ->
	crs = Invitations.find invitation_id

	log_publication crs, undefined , "invitation_by_id"
	return crs


#######################################################
Meteor.publish "invitations_by_organization_id", (organization_id) ->
	check organization_id, String

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	if not has_role Organizations, organization_id, user_id, OWNER
		throw new Meteor.Error "Not permitted."

	filter =
		organization_id: organization_id

	crs = get_documents IGNORE, IGNORE, Invitations, filter, _invitation_fields
	log_publication crs, user_id, "invitations_by_organization_id"

	return crs


#######################################################
Meteor.publish "send_invitations", (admissions) ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	crs = get_my_documents Invitations, {}, {}

	log_publication crs, user_id, "send_invitations"
	return crs

#######################################################
Meteor.publish "received_invitations", (admissions) ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter =
		email: get_user_mail user_id

	crs = Invitations.find filter

	log_publication crs, undefined , "invitation_by_id"
	return crs

