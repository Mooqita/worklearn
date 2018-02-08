###############################################################################
# Top Base Menu
###############################################################################

###############################################################################
Template.mooqita_menu.helpers
	profile: () ->
		user_id = Meteor.userId()
		profile = get_profile(user_id)
		return profile

	menu_items: () ->
		return [{name: "Challenges", href: build_url("challenges")}
						{name: "Solutions", href: build_url("solutions")}
						{name: "Reviews", href: build_url("reviews")}
						{name: "Portfolio", href: build_url("portfolio")}]

	num_new_messages: () ->
		crs = get_my_documents("messages", {seen:false})
		return crs.count()

###############################################################################
Template.mooqita_menu.events
	'click #logout': (event) ->
		Meteor.logout()

