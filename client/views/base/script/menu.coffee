########################################
Template.mooqita_menu.helpers
	sub_menu: () ->
		profile = get_profile()
		if not profile
			return false

		switch profile.occupation
			when "learner" then return "learner_menu"
			when "student" then return "learner_menu"
			when "educator" then return "educator_menu"
			when "teacher" then return "educator_menu"
			when "organization" then return "organization_menu"
			when "company" then return "organization_menu"
			else return false


########################################
Template.mooqita_menu.events
	'click #logout': (event) ->
		Meteor.logout()

