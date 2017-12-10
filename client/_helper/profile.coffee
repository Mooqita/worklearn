########################################
Template.registerHelper "profile", (owner_id=null) ->
	if not owner_id
		owner_id = Meteor.userId()
		
	return get_profile(owner_id)


########################################
Template.registerHelper "profile_id", (owner_id) ->
	filter =
		owner_id: owner_id
	profile = Profiles.findOne filter

	if not profile
		return undefined

	return profile._id


########################################
Template.registerHelper "profile_avatar", (owner_id) ->
	filter =
		owner_id: owner_id
	profile = Profiles.findOne filter

	if not profile
		return undefined

	return profile.avatar


########################################
Template.registerHelper "profile_name", (owner_id) ->
	filter =
		owner_id: owner_id
	profile = Profiles.findOne filter

	return get_profile_name profile, false, false


########################################
Template.registerHelper "_is_owner", (collection_name, obj) ->
	if typeof obj == "string"
		collection = get_collection collection_name
		obj = collection.findOne obj

	owner = obj.owner_id == Meteor.userId()
	return owner


