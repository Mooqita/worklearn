################################################################################
# Describe your job search
################################################################################

################################################################################
# local variables and methods
################################################################################

################################################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

################################################################################
Template.job_describe.onCreated ->
	job_id = FlowRouter.getQueryParam("job_id")

	this.autorun () ->
		admission = get_admission(IGNORE, IGNORE, Jobs, job_id)
		activate_admission(admission)

################################################################################
Template.job_describe.helpers
	get_job:() ->
		job_id = FlowRouter.getQueryParam("job_id")
		return Jobs.findOne(job_id)
