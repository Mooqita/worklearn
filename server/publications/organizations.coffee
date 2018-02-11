###############################################################################
_organization_fields =
	fields:
		name: 1
		avatar: 1
		description: 1

###############################################################################
Meteor.publish "my_organizations", (admissions) ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	crs = get_my_documents Organizations, {}, _organization_fields

	log_publication crs, user_id, "my_organizations"
	return crs


###############################################################################
Meteor.publish "organization_by_id", (organization_id) ->
	check organization_id, String

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter =
		_id: organization_id

	crs = get_my_documents Organizations, filter, _organization_fields
	log_publication crs, user_id, "organization_by_id"
	return crs


