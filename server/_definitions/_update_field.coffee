#######################################################
#
#Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
@__action_permitted = (permission, action) ->
	if not action in permission.actions
		return false

	return true


#######################################################
@__is_owner = (collection_name, id) ->
	collection = get_collection collection_name
	item = collection.findOne(id)

	if not item
		throw new Meteor.Error('Not permitted.')

	if not item.owner_id
		return false

	if item.owner_id == Meteor.userId()
		return true

	return false


#######################################################
@__is_owner_publish = (collection_name, id, user_id) ->
	collection = get_collection collection_name
	item = collection.findOne(id)

	if not item
		throw new Meteor.Error('Not permitted.')

	if not item.owner_id
		return false

	if item.owner_id == user_id
		return true

	return false


#######################################################
@__deny_publish = (collection, id, field, user_id) ->
	check(id, String)
	check(field, String)
	check(collection, String)

	roles = ['all']
	if user_id
		check(user_id, String)
		user = Meteor.users.findOne(user_id)

		if __is_owner_publish collection, id, user_id
			roles.push 'owner'

	if user
		roles.push user.roles ...
		roles.push 'anonymous'

	filter =
		role:
			$in: roles
		field: field
		collection: collection

	permissions = Permissions.find(filter)

	if permissions.count() == 0
		console.log('No permissions found for action: ' + roles)
		throw new Meteor.Error('Not permitted.')

	for permission in permissions.fetch()
		if __action_permitted permission, 'read'
			return false

	throw new Meteor.Error('Not permitted.')


#######################################################
@__deny_action = (action, collection, id, field) ->
	check id, String
	check field, String
	check action, String
	check collection, String

	roles = ['all']
	user = Meteor.user()

	if user
		roles.push user.roles ...
		roles.push 'anonymous'

		if __is_owner_publish collection, id, user._id
			roles.push 'owner'

	filter =
		role:
			$in: roles
		field: field
		collection: collection

	permissions = Permissions.find(filter)

	if permissions.count() == 0
		throw new Meteor.Error('Not permitted.')

	for permission in permissions.fetch()
		if __action_permitted permission, action
			return false

	throw new Meteor.Error('Not permitted.')


#######################################################
@modify_field = (collection_name, id, field, value) ->
	__deny_action('modify', collection_name, id, field)

	check value, Match.OneOf String, Number, Boolean

	s = {}
	s[field] = value

	mod =
		$set:s

	msg = 'Changed ' + field + ' of ' +
			collection_name + ':' + id + ' to ' +
			value.toString().substr(0, 50)
	console.log(msg)

	colllection = get_collection collection_name
	n = colllection.update(id, mod)
	return n

