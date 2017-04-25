########################################
Template.mooqita_menu.helpers
	sub_menu: () ->
		profile = get_profile()
		if not profile
			return false

		switch profile.occupation
			when "student" then return "student_menu"
			when "teacher" then return "teacher_menu"
			when "company" then return "company_menu"
			else return false


Template.mooqita_menu.events
	'click .logout': (event) ->
		event.preventDefault()
		Meteor.logout()

	"click .control-navigate": (event)->
		lnk = event.target.id
		if lnk
			param =
				template: lnk

			FlowRouter.go "/user", null, param

