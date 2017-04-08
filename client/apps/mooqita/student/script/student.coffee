########################################
#
# student view
#
########################################

########################################
Template.student_view.onCreated ->
	Session.set "current_data", null
	Session.set "student_template", "student_profile"

########################################
Template.student_view.helpers
	data: () ->
		data = 	Session.get "current_data"
		return if data then data else this

	selected_view: () ->
		return Session.get "student_template"

########################################
Template.student_menu.events
	"click .student_navigate": (event)->
		lnk = event.target.id
		if lnk
			Session.set "student_template", lnk

