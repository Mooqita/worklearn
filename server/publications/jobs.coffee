###############################################################################
_job_fields =
	fields:
		title: 1
		description: 1
		role: 1
		idea: 1
		team: 1
		process: 1
		strategic: 1
		player: 1
		organization_id: 1
		challenge_ids: 1

###############################################################################
Meteor.publish "my_jobs", (admissions) ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	crs = get_documents user_id, IGNORE, Jobs, {}, _job_fields

	log_publication crs, user_id, "my_jobs"
	return crs


###############################################################################
Meteor.publish "job_by_id", (job_id) ->
	check job_id, String

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter =
		_id: job_id

	crs = get_documents IGNORE, IGNORE, Jobs, filter, _job_fields

	log_publication crs, user_id, "job_by_id"
	return crs


