#######################################################
#
#Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
@store_document_unprotected = (collection, document, owner)->
	document["created"] = new Date()
	document["modified"] = new Date()

	id = collection.insert document
	item = collection.findOne id

	if not owner
		return id

	user = Meteor.users.findOne owner._id

	gen_admission collection._name, item, user, OWNER
	return id


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

