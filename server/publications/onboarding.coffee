###############################################################################
_job_fields =
	fields:
		role:1,
		idea:1,
		team:1,
		process:1,
		strategic:1
		organization_id:1

###############################################################################
_organization_fields =
	fields:
		name: 1


###############################################################################
Meteor.publish "my_jobs", (admissions) ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	crs = get_my_documents Jobs, {}, _job_fields

	log_publication crs, user_id, "my_jobs"
	return crs


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
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter =
		_id:organization_id

	crs = get_my_documents Organizations, filter, _organization_fields
	log_publication crs, user_id, "organization_by_id"
	return crs


###############################################################################
Meteor.publish "team_members", (organization_id) ->
	check organization_id, String

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	member_ids = []
	admission_cursor = get_admissions IGNORE, IGNORE, Organizations, organization_id
	admission_cursor.forEach (admission) ->
		member_ids.push admission.consumer_id

	options =
		fields:
			given_name: 1
			middle_name: 1
			family_name: 1
			big_five: 1

	self = this
	for user_id in member_ids
		profile = Profiles.findOne {user_id: user_id}, options
		mail = get_user_mail(user_id)
		name = get_profile_name profile, false, false

		member =
			name: name
			email: mail
			big_five: profile.big_five

		self.added("team_members", user_id, member)

	log_publication admission_cursor, user_id, "team_members"
	self.ready()

