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
Meteor.publish "job_by_id", (job_id) ->
	check job_id, String

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter =
		_id: job_id

	crs = get_my_documents Jobs, filter, _job_fields

	log_publication crs, user_id, "job_by_id"
	return crs


###############################################################################
Meteor.publish "my_jobs", (admissions) ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	crs = get_my_documents Jobs, {}, _job_fields

	log_publication crs, user_id, "my_jobs"
	return crs


