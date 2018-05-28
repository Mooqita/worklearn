#########################################################
#
# Onboarding
#
#########################################################

##########################################################
# local variables and methods
##########################################################

##########################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter

##########################################################
# Jobs
##########################################################

#########################################################
Template.jobs.onCreated () ->

##########################################################
Template.jobs.events
	"click #add_job": () ->
		Modal.show 'job_select_org'

#########################################################
# Select organization
#########################################################

#########################################################
Template.job_select_org.onCreated () ->
	self = this
	self.selected_org = new ReactiveVar(undefined)

	self.update_selected = (event) ->
		org = $('.user_select_class').val()
		self.selected_org.set org


#########################################################
Template.job_select_org.onRendered () ->
	$(".selectpicker").selectpicker()

#########################################################
Template.job_select_org.helpers
	org_selected: () ->
		inst = Template.instance()
		org = inst.selected_org.get()
		return org

	organizations: () ->
		return Organizations.find()

#########################################################
Template.job_select_org.events
	"show.bs.select .user_select_class": () ->
		inst = Template.instance()

		$(".selectpicker").off "changed.bs.select", inst.update_selected
		$(".selectpicker").on "changed.bs.select", inst.update_selected

	"click #add_job": () ->
		inst = Template.instance()
		organization_id = inst.selected_org.get()

		Meteor.call "add_job", organization_id,
			(err, res) ->
				if err
					sAlert.error("Add challenge error: " + err)
				if res
					query =
						job_id: res
						organization_id: organization_id
					url = build_url "job_posting", query
					FlowRouter.go url


#########################################################
# Job preview
#########################################################

#########################################################
Template.job_preview.onCreated () ->
	self = this
	self.autorun ()->
		data = self.data
		id = data.organization_id
		self.subscribe("organization_by_id", id)

#########################################################
Template.job_preview.helpers
	title: () ->
		inst = Template.instance()
		data = inst.data
		if data.title
			return data.title
		return "Click here to edit your job posting."

	get_role: () ->
		inst = Template.instance()
		data = inst.data

		map =
			marketing: "Marketing"
			design: "Design"
			sales: "Sales"
			other: "Other"
			ops: "Operations"
			dev: "Engineering"

		res = map[data.role]
		return res

	get_organization: () ->
		inst = Template.instance()
		data = inst.data

		id = data.organization_id
		org = Organizations.findOne id

		return org


#########################################################
# Job posting
#########################################################

#########################################################
Template.job_posting.onCreated () ->
	self = this
	this.autorun () ->
		job_id = FlowRouter.getQueryParam("job_id")
		self.subscribe("job_by_id", job_id)


#########################################################
Template.job_posting.helpers
	get_job: () ->
		job_id = FlowRouter.getQueryParam("job_id")
		job = Jobs.findOne(job_id)
		return job

	publish_disable: () ->
		return "disabled"


#########################################################
Template.job_posting.events
	"click #save":()->
		sAlert.success("Posting saved")
