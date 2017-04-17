#######################################################
_accepts =
	type_identifier: String
	challenge_id: non_empty_string
	solution_id: non_empty_string
	template_id: non_empty_string
	group_name: String
	parent_id: non_empty_string
	owner_id: non_empty_string
	index: Match.OneOf String, Number
	text: String
	_id: non_empty_string

#######################################################
@log_publication = (crs, filter, fields, mine, header_only, origin) ->
	data = if header_only then "without data" else "with data"
	console.log "Submitted " + crs.count() + " responses " + data + " to " + origin

	f = JSON.stringify(filter, null, 2);
	console.log f

#	console.log "With fields"

#	m = JSON.stringify(fields, null, 2);
#	console.log m

#######################################################
@get_collection = (collection_name) ->
	collection = this[collection_name]
	if not collection instanceof Meteor.Collection
		return undefined

	return collection


#######################################################
@action_permitted = (permission, action) ->
	if permission[action]!=true
		return false

	return true


#######################################################
@is_owner = (collection_name, id, user_id) ->
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
@make_filter_save = (user_id, param) ->
	check user_id, Match.OneOf String, undefined, null

	restrict = {}

	for field_name, value of _accepts
		if field_name of param
			check param[field_name], value
			if field_name == "text"
				restrict["$text"] =
					$search: param[field_name]
			else
				restrict[field_name] = param[field_name]

	return restrict


#######################################################
@deny_action_save = (action, collection_name, id, field) ->
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

		if is_owner collection_name, id, user._id
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
		if action_permitted permission, action
			return false

	throw new Meteor.Error('Not permitted.')


