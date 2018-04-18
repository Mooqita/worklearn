###############################################################################
#
# Created by Markus on 26/10/2017.
#
###############################################################################

###############################################################################
@set_field = (collection, item_id, field, value) ->
	user = Meteor.user()

	if not user
		throw new Meteor.Error "Not permitted"

	if not collection
		throw new Meteor.Error "Collection undefined."

	type = Match.OneOf String, Number, Boolean
	array = [type]
	obj = Match.Where (x) ->
		l = Object.keys(x).length
		if l > 1000
			return false

		for key, val of x
			check key, String
			check val, type

		return true

	check value, Match.OneOf type, array, obj
	check item_id, String
	check field, String

	csn = can_edit collection, item_id, user

	if not collection.findOne({owner_id: user._id})
		throw new Meteor.Error("Not permitted.")

	res = modify_field_unprotected collection, item_id, field, value, user

	return res

@set_challenge_field = (item_id, field, value) ->
	user = Meteor.user()

	if not user
		throw new Meteor.Error "Not permitted"

	if not Challenges.findOne({_id: item_id, owner_id: user._id})
		throw new Meteor.Error("Not permitted.")

	res = modify_field_unprotected Challenges, item_id, field, value, user

	return res

@set_profile_field = (item_id, field, value) ->
	user = Meteor.user()

	# if not user
	#	throw new Meteor.Error "Not permitted"

	if not Profiles.findOne({user_id: user._id})
		throw new Meteor.Error("Profile not found.")

	res = modify_field_unprotected Profiles, item_id, field, value, user

	return res

###############################################################################
@set_element = (collection, item_id, field, value) ->
	user = Meteor.user()
	if not user
		throw new Meteor.error "Not permitted"

	if not collection
		throw new Meteor.Error "Collection undefined."

	check value, Match.OneOf String, Number, Boolean
	check item_id, String
	check field, String

	csn = can_edit collection, item_id, user

	if not csn
		throw new Meteor.Error "Not permitted."

	res = modify_field_unprotected collection, item_id, field, value
	return res


###############################################################################
@modify_field_unprotected = (collection, id, field, value, user) ->
	if not collection
		throw new Meteor.Error "Collection undefined."

	check id, String

	s = {}
	s[field] = value
	s['modified'] = new Date

	mod =
		$set:s

	n = collection.update(id, mod)
	collection_name = get_collection_name collection

	#if typeof value == "string"
	#	handle_text(collection_name, id, field, user)

	msg = "[" + collection_name + "] "
	msg += "[" + field + "] "
	msg += "[" + id + "] "
	msg += "set to [" + value.toString().substr(0, 30) + "]"

	log_event msg, event_db, event_edit
	return n
