#######################################################
_accepts =
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
@paged_find = (collection, filter, mod, parameter) ->
	parameter.size = if parameter.size > 100 then 100 else parameter.size

	if parameter.query
		filter["$text"] =
			$search: parameter.query

		if not mod.fields
			mod.fields = {}

		mod.fields.score = {$meta: "textScore"}

	mod.limit = parameter.size
	mod.skip = parameter.size*parameter.page

	if parameter.query
		mod.sort =
			score:
				$meta: "textScore"

	crs = collection.find filter, mod
	return crs


#######################################################
@get_collection_save = (collection_name) ->
	check collection_name, String
	collection = get_collection collection_name

	if not collection
		throw new Meteor.Error "Collection not found: " + collection_name

	return collection


#######################################################
@action_permitted = (permission, action) ->
	if permission[action]!=true
		return false

	return true


#######################################################
@is_owner = (collection, id, user_id) ->
	if not collection
		throw new Meteor.Error('Collection not found:' + collection)

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
			if not param[field_name]
				msg = "parameter " + field_name + " is empty."
				log_event msg, event_db, event_warn
				return {}
			else
				check param[field_name], value
			if field_name == "text"
				restrict["$text"] =
					$search: param[field_name]
			else
				restrict[field_name] = param[field_name]

	return restrict


#######################################################
@deny_action_save = (action, collection, item_id, field) ->
	if not collection
		throw new Meteor.Error "Collection undefined."

	if not field
		throw new Meteor.Error "Field undefined."

	if not item_id
		throw new Meteor.Error "Item_id undefined."

	check item_id, String
	check action, String
	check field, String

	roles = ['all']
	user = Meteor.user()

	if user
		roles.push user.roles ...
		roles.push 'anonymous'

		if is_owner collection, item_id, user._id
			roles.push 'owner'

	filter =
		role:
			$in: roles
		field: field
		collection_name: collection._name

	permissions = Permissions.find(filter)

	if permissions.count() == 0
		throw new Meteor.Error action + ' not permitted: ' + field

	for permission in permissions.fetch()
		if action_permitted permission, action
			return false

	throw new Meteor.Error action + ' not permitted: ' + field


