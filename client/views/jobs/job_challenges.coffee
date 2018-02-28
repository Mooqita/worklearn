###############################################################################
#
# Job challenges
#
###############################################################################

################################################################################
# local variables and methods
################################################################################

################################################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

###############################################################################
Template.job_challenges.onRendered () ->
	job_id = FlowRouter.getQueryParam("job_id")
	organization_id = FlowRouter.getQueryParam("organization_id")

	this.autorun () ->
		job_ad = get_admission(IGNORE, IGNORE, Jobs, job_id)
		activate_admission(job_ad)

		organization_ad = get_admission(IGNORE, IGNORE, Organizations, organization_id)
		activate_admission(organization_ad)


###############################################################################
Template.job_challenges.helpers
	job: () ->
		id = FlowRouter.getQueryParam("job_id")
		return Jobs.findOne(id)

	challenges: () ->
		challenges = Challenges.find().fetch()
		if challenges and Array.isArray(challenges) and challenges.length > 0
			chall_count = 0

			for challenge in challenges
				is_string = typeof challenge.title == "string"

				if is_string && challenge.title != ""
					challenge.title = challenge.title.substring(0,46) + " [...]"
				else
					chall_count++
					challenge.title = "Untitled challenge " + chall_count

		return challenges

###############################################################################
Template.job_challenges.events
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

#########################################################
# Job challenges preview
#########################################################

#########################################################
Template.job_challenges_preview.onCreated () ->
	self = this
	self.autorun ()->
		self.subscribe "challenges_by_ids", self.data.challenge_ids

#########################################################
Template.job_challenges_preview.helpers
	challenges: () ->
		inst = Template.instance()
		ids = inst.data.challenge_ids

		if not ids
			ids = []

		filter =
			_id:
				$in: ids

		return Challenges.find(filter)

