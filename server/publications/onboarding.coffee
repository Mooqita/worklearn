#######################################################
_job_fields =
	fields:
		role:1,
		idea:1,
		team:1,
		process:1,
		strategic:1
		organization_id:1

#######################################################
_organization_fields =
	fields:
		name: 1


#######################################################
Meteor.publish "my_jobs", (admissions) ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	crs = get_my_documents Jobs, {}, _job_fields

	log_publication crs, user_id, "my_jobs"
	return crs


#######################################################
Meteor.publish "my_organizations", (admissions) ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	crs = get_my_documents Organizations, {}, _organization_fields

	log_publication crs, user_id, "my_organizations"
	return crs

