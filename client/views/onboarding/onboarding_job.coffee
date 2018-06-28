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
Template.onboarding_job_info.onCreated () ->
	self = this
	self.autorun () ->
		mod =
			fields:
				_id:1
				ids:1
				cb:1

		matches = Matches.find({}, mod).fetch()
		Meteor.subscribe("users_by_matched_challenges", matches)

		item_id = self.data.item_id
		text = Session.get("onboarding_job_description")
		item_id = fast_hash(text)

		parameter =
			page: 0
			size: 100
			item_id: item_id

		self.subscribe("my_matches", parameter)


################################################################################
Template.onboarding_job_info.helpers
	has_text: () ->
		text = Session.get("onboarding_job_description")
		if not text
			return false

		return text.length > 5

	work_days: () ->
		text = Session.get("onboarding_job_description")
		if not text
			return false

		days = if text.length > 1500 then 3 else 2
		return days

	enough_challenges: () ->
		return Matches.find().count() > 2

	enough_candidates: () ->
		return UserResumes.find().count() > 5

	num_challenges: () ->
		return Matches.find().count()

	num_candidates: () ->
		return UserResumes.find().count()



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




