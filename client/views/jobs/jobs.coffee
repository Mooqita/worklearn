#########################################################
#
# Onboarding
#
#########################################################

##########################################################
# local variables and methods
##########################################################

##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

##########################################################
# Jobs
##########################################################

#########################################################
Template.jobs.onCreated () ->
	this.subscribe "my_organizations", []

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
					url = build_url "challenge_design", query
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
		Meteor.subscribe("organization_by_id", id)

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
	self.autorun ()->
		job_id = FlowRouter.getQueryParam("job_id")
		organization_id = FlowRouter.getQueryParam("organization_id")

		self.subscribe "job_by_id", job_id
		self.subscribe "organization_by_id", organization_id
		self.subscribe "invitations_by_organization_id", organization_id


#########################################################
Template.job_posting.helpers
	job: () ->
		id = FlowRouter.getQueryParam("job_id")
		return Jobs.findOne(id)

	organization_id: () ->
		id = FlowRouter.getQueryParam("organization_id")
		return id

	job_persona: (data) ->
		job = persona_build(data)
		return job

	team_persona: () ->
		members = TeamMembers.find().fetch()
		team = persona_extract_requirements(members)

		if not team
			return team

		team = persona_normalize(team)
		team = persona_invert(team, 0.2)
		team = persona_map team, persona_map_person_to_job

		return team

	optimal_persona: (data) ->
		members = TeamMembers.find().fetch()
		team = persona_extract_requirements(members)
		if not team
			return undefined

		job = persona_build(data)
		res = persona_optimize_team(team, job)

		return res


#########################################################
Template.job_posting.events
	"click #new_job": () ->
		data = Session.get "onboarding_job_posting"
		if data
			Meteor.call "add_job_post", data
		else
			sAlert.error "missing job posting data"

	"click #add_challenge": () ->
		loc_job_id = FlowRouter.getQueryParam("job_id")
		Meteor.call "add_challenge", loc_job_id,
			(err, res) ->
				if err
					sAlert.error("Add challenge error: " + err)
				if res
					query =
						challenge_id: res
						job_id: loc_job_id
					url = build_url "challenge_design", query
					FlowRouter.go url

	"click #template_challenge": () ->
		loc_job_id = FlowRouter.getQueryParam("job_id")
		query =
			job_id: loc_job_id
		url = build_url "challenge_pool", query
		FlowRouter.go url