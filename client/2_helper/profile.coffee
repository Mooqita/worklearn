########################################
Template.registerHelper "g_profile", (owner_id=null) ->
	if not owner_id
		owner_id = Meteor.userId()
		
	return get_profile owner_id


########################################
Template.registerHelper "g_profile_id", (owner_id) ->
	profile = get_profile owner_id

	if not profile
		return undefined

	return profile._id


########################################
Template.registerHelper "g_profile_avatar", (owner_id) ->
	profile = get_profile owner_id

	if not profile
		return undefined

	return profile.avatar


########################################
Template.registerHelper "g_profile_name", (owner_id) ->
	profile = get_profile owner_id

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

