################################################################
@gen_job = (job, user) ->
	if not user
		user = Meteor.userId()

	if typeof user != "string"
		user = user._id

	job_id = store_document_unprotected Jobs, job, user
	return job_id
