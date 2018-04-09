########################################
Template.registerHelper "g_profile", (user_id=null) ->
	return get_profile user_id


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

	return profile.avatar


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
Template.registerHelper "g_name_from_profile", (profile, short) ->
	if not profile
		profile = get_profile()

	if not profile
		return undefined

	return get_profile_name profile, short, false


########################################
Template.registerHelper "g_is_owner", (collection_name, obj) ->
	if typeof obj == "string"
		collection = get_collection collection_name
		obj = collection.findOne obj

	user_id = Meteor.userId()
	owner_ids = get_document_owners collection_name, obj._id
	for owner in owner_ids
		if owner == user_id
			return true

	return false

