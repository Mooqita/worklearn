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

	crs = get_documents user_id, IGNORE, Organizations, {}, _organization_fields

	log_publication crs, user_id, "my_organizations"
	return crs


###############################################################################
Meteor.publish "organization_by_id", (organization_id) ->
	check organization_id, String

	user_id = this.userId

	filter =
		_id: organization_id

	crs = get_documents IGNORE, IGNORE, Organizations, filter, _organization_fields
	log_publication crs, user_id, "organization_by_id"
	return crs


###############################################################################
Meteor.publish "organizations_by_admissions", (admissions) ->
	param =
		_id: String
		c: String
		u: String
		i: String
		r: String
	check admissions, [param]

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	ids = []
	for admission in admissions
		ids.push(admission.i)

	filter =
		_id:
			$in: ids

	crs = get_documents IGNORE, IGNORE, Organizations, filter, _organization_fields
	log_publication crs, user_id, "organizations_by_admissions"
	return crs


