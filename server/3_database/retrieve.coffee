#######################################################
#
# Created by Markus on 26/10/2016.
#
#######################################################

#######################################################
@get_collection_save = (collection_name) ->
	check collection_name, String
	collection = get_collection collection_name

	if not collection
		throw new Meteor.Error "Collection not found: " + collection_name

	return collection

#######################################################
@get_documents_paged_unprotected = (collection, filter, mod, parameter) ->
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
@get_visible_fields = (collection, user_id, filter) ->
	throw new Meteor.Error "@get_visible_fields is not implemented."

	owner = false

	if filter.owner_id
		if filter.owner_id == user_id
			owner = true

	roles = ['all']
	if owner
		roles.push 'owner'

	if user_id
		user = Meteor.users.findOne(user_id)

	if user
		roles.push user.roles ...
		roles.push 'anonymous'

	res = {}
	edit_fields = Permissions.find({}, {fields:{field:1}}).fetch()

	for field in edit_fields
		filter =
			role:
				$in: roles
			field: field.field
			collection_name: collection._name

		permissions = Permissions.find(filter)

		if permissions.count() == 0
			continue

		for permission in permissions.fetch()
			if action_permitted permission, 'read'
				res[field["field"]] = 1

	mod =
		fields: res

	return mod


#######################################################
@can_edit_field = (collection, item_id, field, user) ->
	if not collection
		throw new Meteor.Error "Collection undefined."

	if not field
		throw new Meteor.Error "Field undefined."

	if not item_id
		throw new Meteor.Error "Item_id undefined."

	if not user
		user = Meteor.user()

	if not collection
		throw new Meteor.Error "Not permitted."

	check item_id, String
	check field, String

	roles = get_roles collection, item_id, user
	field = field.split(".")[0]
	filter =
		role:
			$in: roles
		field: field
		collection_name: collection._name

	permissions = Permissions.find filter

	if permissions.count() == 0
		throw new Meteor.Error 'Edit not permitted: ' + field

	for permission in permissions.fetch()
		if permission[action]==true
			return true

	throw new Meteor.Error 'Edit not permitted: ' + field


#######################################################
@backup_collection = (collection_name) ->
	collection = get_collection_save collection_name
	data = export_data(collection)
	return data

