########################################
#
# company view
#
########################################

########################################
Template.company_view.onCreated ->
	Session.set "company_data", null
	Session.set "company_template", "company_profile"

########################################
Template.company_view.helpers
	data: () ->
		data = 	Session.get "company_data"
		return if data then data else this

	selected_view: () ->
		return Session.get "company_template"

########################################
Template.company_menu.events
	"click .company_navigate": (event)->
		lnk = event.target.id
		if lnk
			Session.set "company_template", lnk
