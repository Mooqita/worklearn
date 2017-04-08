########################################
#
# student profile
#
########################################

########################################
Template.student_profile.onCreated ->
	user_id = Meteor.userId()
	self = this

	self.autorun () ->
		filter =
			type_identifier: "profile"
			owner_id: user_id

		self.subscribe "responses", filter, true, false, "student_profile",

########################################
Template.student_profile.helpers
	profile: () ->
		filter =
			type_identifier: "profile"

		res = Responses.findOne filter
		return res

########################################
Template.student_profile.events

