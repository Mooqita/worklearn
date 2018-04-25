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
		unique = get_admission_collection_names()

		items = [	{name: "Organizations", href: build_url("organizations")}]

		if unique.has("organizations")
		 items.push({name: "Job Postings", href: build_url("jobs")})

		items.push({name: "Challenges", href: build_url("designed_challenges")})
		items.push({name: "Education", href: build_url("learner_education")})
		items.push({name: "My Profile", href: build_url("profile")})

		#{name: "Portfolio", href: build_url("portfolio")}
		#filter =
		#	collection_name: "organizations"
		#if Admissions.find(filter).count() > 0

		if unique.has("solutions")
		 items.push({name: "Solutions", href: build_url("solutions")})
		 items.push({name: "Reviews", href: build_url("reviews")})
		 items.push({name: "Portfolio", href: build_url("portfolio")})


		return items

	num_new_messages: () ->
		crs = get_my_documents("messages", {seen:false})
		return crs.count()

###############################################################################
Template.mooqita_menu.events
	'click #logout': (event) ->
		Meteor.logout()
