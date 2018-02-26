###############################################################################
_job_fields =
	fields:
		title: 1
		description: 1
		role: 1
		idea: 1
		team: 1
		social: 1
		process: 1
		strategic: 1
		contributor: 1
		organization_id: 1
		challenge_ids: 1

###############################################################################
Meteor.publish "jobs_by_admissions", (admissions) ->
	param =
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
		ids.push(admission._id)

	filter =
		_id:
			$in: ids

	crs = get_documents IGNORE, IGNORE, Jobs, filter, _job_fields
	log_publication crs, user_id, "jobs_by_admissions"
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


