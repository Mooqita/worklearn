Template.student_menu.helpers
	credits: () ->
		profile = get_profile()
		r = profile.requested
		p = profile.provided

		console.log profile

		return p-r

	new_messages: () ->
		profile = get_profile()
		return profile.new_messages
