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
#
# Describe your job post
#
################################################################################

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
		text = Session.get("onboarding_job_data")
		if not text
			return false

		text = text.description
		if not text
			return false

		return text.length > 15

	saved: () ->
		text = Session.get("onboarding_job_data")
		if not text
			return false

		text = text.description
		if not text
			return false

		return text.length > 0

	work_days: () ->
		text = Session.get("onboarding_job_data")
		if not text
			return false

		text = text.description
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
# Job tier
################################################################################

_on_login = (res) ->
	data = Session.get("onboarding_job_data")

	Meteor.call "add_challenge_from_data", data,
		(err, res) ->
			if err
				sAlert.error("Error creating your challenge: " + err)
				return

			query =
				challenge_id: res
			FlowRouter.go(build_url("challenge_design", query))


################################################################################
Template.onboarding_job_tier.onCreated () ->
	self = this

	self.autorun () ->
		user_id = Meteor.userId()
		if user_id
			_on_login(null)


################################################################################
Template.onboarding_job_tier.events
	"click .register-button": () ->
		if not Meteor.user()
			Modal.show 'onboarding_job_register'


################################################################################
Template.onboarding_job_register.onCreated () ->
	AccountsTemplates.setState("signUp")


################################################################################
Template.onboarding_job_register.onDestroyed () ->
	AccountsTemplates.setState("signIn")
