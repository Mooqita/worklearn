#######################################################
#
# Created by Markus on 26/10/2017.
#
#######################################################

#######################################################
@modify_field = (collection, item_id, field, value) ->
	if not collection
		throw new Meteor.Error "Collection undefined."

	check value, Match.OneOf String, Number, Boolean
	check item_id, String
	check field, String

	if not can_edit collection, item_id, field
		throw new Meteor.Error "Not permitted."

	res = modify_field_unprotected collection, id, field, value

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

	msg = "[collection_name] " + collection._name
	msg += " [field] " + field + ' of ' +
	msg += " [item] " + id
	msg += " [value] " + value.toString().substr(0, 50)

	log_event msg, event_edit, event_info
	return n


