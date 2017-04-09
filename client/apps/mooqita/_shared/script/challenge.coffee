Template.challenge.helpers
	profile: () ->
		filter =
			type_identifier: "profile"

		res = Responses.findOne filter
		return res