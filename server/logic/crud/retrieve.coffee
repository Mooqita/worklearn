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
	mod.skip = parameter.size * parameter.page
	mod.sort =
		pined: 1

	if parameter.query
		mod.sort =
			score:
				$meta: "textScore"

	switch parameter.sort_by
		when "relevance" then true
		when "date_created_inc" then mod.sort.created = 1
		when "date_created_dec" then mod.sort.created = -1
		when "date_modified_inc" then mod.sort.modified = 1
		when "date_modified_dec" then mod.sort.modified = -1
		when "rated_inc" then mod.sort.rated = 1
		when "rated_dec" then mod.sort.rated = -1
		when "time_needed_inc" then mod.sort.rated = 1
		when "time_needed_dec" then mod.sort.rated = -1
		when "complexity_inc" then mod.sort.complexity = 1
		when "complexity_dec" then mod.sort.complexity = -1

	crs = collection.find(filter, mod)
	return crs


#######################################################
@get_visible_fields = (user, role, collection, filter) ->
	throw new Meteor.Error "@get_visible_fields is not implemented."

	roles = [PUBLIC]

	if user
		roles.push USER

	res = {}
	edit_fields = get_documents user, role, Permissions, filter
	edit_fields = edit_fields.fetch()
	collection_name = get_collection_name collection

	for field in edit_fields
		filter =
			role:
				$in: roles
			field: field.field
			collection_name: collection_name

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

	collection_name = get_collection_name collection
	roles = get_roles user, collection, item_id
	field = field.split(".")[0]
	filter =
		role:
			$in: roles
		field: field
		collection_name: collection_name

	permissions = Permissions.find filter

	if permissions.count() == 0
		throw new Meteor.Error 'Edit not permitted: ' + field

	for permission in permissions.fetch()
		if permission["modify"]==true
			return true

	throw new Meteor.Error 'Edit not permitted: ' + field


#######################################################
@backup_collection = (collection_name) ->
	collection = get_collection_save collection_name
	data = export_data(collection)
	return data

