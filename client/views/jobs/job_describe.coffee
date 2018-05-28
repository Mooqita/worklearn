################################################################################
# Describe your job search
################################################################################

################################################################################
# local variables and methods
################################################################################

################################################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter

################################################################################
Template.job_describe.onCreated ->
	self = this
	self.autorun () ->
		id = FlowRouter.getQueryParam("job_id")
		self.subscribe("job_by_id", id)

################################################################################
Template.job_describe.helpers
	get_job:() ->
		job_id = FlowRouter.getQueryParam("job_id")
		return Jobs.findOne(job_id)
