########################################
Template.registerHelper "g_profile", (owner_id=null) ->
	return get_profile owner_id


########################################
Template.registerHelper "g_profile_id", (user) ->
	profile = get_profile user

	if not profile
		return undefined

	return profile._id


########################################
Template.registerHelper "g_profile_avatar", (user) ->
	profile = get_profile user

	if not profile
		return undefined

	return get_avatar profile


########################################
Template.registerHelper "g_profile_name", (user) ->
	profile = get_profile user

	if not profile
		return undefined

	return get_profile_name profile, false, false


########################################
Template.registerHelper "g_profile_first_name", (user) ->
	profile = get_profile user

	if not profile
		return undefined

	return get_profile_name profile, true, false


########################################
Template.registerHelper "g_name_from_profile", (profile) ->
	if not profile
		profile = get_profile()

	if not profile
		return undefined

	return get_profile_name profile, false, false


########################################
Template.registerHelper "g_is_owner", (collection_name, obj) ->
	if typeof obj == "string"
		collection = get_collection collection_name
		obj = collection.findOne obj

	owner_cursor = get_document_owners "profiles", profile._id
	owner_cursor.forEach (owner) ->
		if owner._id == Meteor.userId()
			return true

	return false

