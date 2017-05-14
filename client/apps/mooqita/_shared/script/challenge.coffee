Template.challenge.helpers
	profile: () ->
		res = Profiles.findOne()
		return res