#######################################################
#
#Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
_action_permitted = (permission, action) ->
	if permission[action]!=true
		return false

	return true


#######################################################
_is_owner = (collection_name, id, user_id) ->
	collection = get_collection collection_name
	if not collection
		throw new Meteor.Error('Collection not found:'+collection_name)

	item = collection.findOne(id)

	if not item
		throw new Meteor.Error('Not permitted.')

	if not item.owner_id
		return false

	if item.owner_id == user_id
		return true

	return false


#######################################################
_deny_action = (action, collection_name, id, field) ->
	if not collection_name
		console.log "collection_name is: " + collection_name

	if not field
		console.log "filed is: " + field

	if not id
		console.log "id is: " + id

	check id, String
	check field, String
	check action, String
	check collection_name, String

	roles = ['all']
	user = Meteor.user()

	if user
		roles.push user.roles ...
		roles.push 'anonymous'

		if __is_owner collection_name, id, user._id
			roles.push 'owner'

	filter =
		role:
			$in: roles
		field: field
		collection: collection_name

	permissions = Permissions.find(filter)

	if permissions.count() == 0
		throw new Meteor.Error('Not permitted.')

	for permission in permissions.fetch()
		if _action_permitted permission, action
			return false

	throw new Meteor.Error('Not permitted.')


#######################################################
@modify_field = (collection_name, id, field, value) ->
	_deny_action('modify', collection_name, id, field)

	check value, Match.OneOf String, Number, Boolean

	s = {}
	s[field] = value
	s['modified'] = new Date

	mod =
		$set:s

	colllection = get_collection collection_name
	n = colllection.update(id, mod)

	msg = 'Changed ' + field + ' of ' +
			collection_name + ':' + id + ' to ' +
			value.toString().substr(0, 50)

	console.log(msg)

	return n

