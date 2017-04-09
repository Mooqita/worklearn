########################################
#
# student profile
#
########################################

########################################
Template.student_profile.onCreated ->

########################################
Template.student_profile.helpers
	profile: () ->
		filter =
			type_identifier: "profile"

		res = Responses.findOne filter
		return res

########################################
Template.student_profile.events

