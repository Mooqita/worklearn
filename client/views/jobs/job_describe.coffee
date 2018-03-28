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
	this.autorun () ->
		id = FlowRouter.getQueryParam("job_id")
		Meteor.subscribe("job_by_id", id)

################################################################################
Template.job_describe.helpers
	get_job:() ->
		job_id = FlowRouter.getQueryParam("job_id")
		return Jobs.findOne(job_id)
