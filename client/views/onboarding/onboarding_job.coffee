###############################################################################
#
# Onboarding
#
###############################################################################

###############################################################################
# local variables and methods
################################################################################

################################################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter

################################################################################
_check_session = () ->
	if not Session.get "onboarding_job_description"
		Session.set "onboarding_job_description", ""

	if not Session.get "user_occupation"
		Session.set "user_occupation", "company"

	if not Session.get "onboarding_job_posting"
		Session.set "onboarding_job_posting", {}

	if not Session.get "onboarding_persona_data"
		Session.set "onboarding_persona_data", persona_job


################################################################################
#
# Onboarding Role
#
################################################################################

################################################################################
Template.onboarding_job_role.onCreated ->
	#_check_session()


################################################################################
#
# Onboarding Competency
#
################################################################################

################################################################################
Template.onboarding_job_competency.onCreated ->
	#_check_session()


################################################################################
#
# Describe your job post
#
################################################################################

################################################################################
#Template.onboarding_job_registration.onCreated () ->
	#_check_session()


################################################################################
#Template.onboarding_job_registration.helpers
#	text: () ->
#		return Session.get("text")

#	has_text: () ->
#		text = Session.get("text")
#		return text.length>10


################################################################################
#Template.onboarding_job_registration.events
#	"click #register": () ->
#		Modal.show 'onboarding_job_register'


################################################################################
#
# Onboarding Finish
#
################################################################################

################################################################################
Template.onboarding_candidates.onCreated () ->
	self = this
	self.autorun () ->
		mod =
			fields:
				_id:1
				ids:1
				cb:1

		matches = Matches.find({}, mod).fetch()
		Meteor.subscribe("user_resumes_by_matched_challenges", matches)


################################################################################
Template.onboarding_candidates.helpers
	candidates: () ->
		return UserResumes.find()




