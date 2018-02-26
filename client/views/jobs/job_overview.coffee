################################################################################
# Job Description
################################################################################

################################################################################
# local variables and methods
################################################################################

################################################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

################################################################################
Template.job_describe.onRendered ->
	job_id = FlowRouter.getQueryParam("job_id")
	admission = get_admission(IGNORE, IGNORE, Jobs, job_id)
	activate_admission(admission)

################################################################################
Template.job_describe.helpers
	get_job: () ->
		job_id = FlowRouter.getQueryParam("job_id")
		Jobs.findOne(job_id)

