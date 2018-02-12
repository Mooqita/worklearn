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
	get_role: () ->
		inst = Template.instance()
		data = inst.data

		id = data.organization_id
		org = Organizations.findOne id

		map =
			marketing: "Marketing"
			design: "Design"
			sales: "Sales"
			other: "Other"
			ops: "Operations"
			dev: "Engineering"

		res = "No title yet"

		if org
			res = org.name + ": "

		res += map[data.role]
		return res


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

		if self.subscriptionsReady()
			if Organizations.find().count() == 0
				Meteor.call "onboard_organization", data


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

