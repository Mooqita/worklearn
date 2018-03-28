################################################################
@gen_job = (job, user) ->
	if not user
		user = Meteor.userId()

	if typeof user != "string"
		user = user._id

	if not job
		job =
			description: ""
			organization_id: ""

	job_id = store_document_unprotected Jobs, job, user, true
	return job_id
