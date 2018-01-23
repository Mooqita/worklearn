#######################################################
#
# Created by Markus on 26/10/2017.
#
#######################################################

#######################################################
@set_field = (collection, item_id, field, value) ->
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

	#if typeof value == "string"
		#predaid_add_text collection, id, field

	return res


#######################################################
@modify_field_unprotected = (collection, id, field, value) ->
	if not collection
		throw new Meteor.Error "Collection undefined."

	check id, String

	s = {}
	s[field] = value
	s['modified'] = new Date

	mod =
		$set:s

	n = collection.update(id, mod)

	msg = "[" + collection._name + "] "
	msg += "[" + field + "] "
	msg += "[" + id + "] "
	msg += "set to [" + value.toString().substr(0, 30) + "]"

	log_event msg, event_db, event_edit
	return n


