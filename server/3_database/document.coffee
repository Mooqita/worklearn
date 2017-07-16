#######################################################
#
#Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
@store_document_unprotected = (collection, document)->
	document["created"] = new Date()
	document["modified"] = new Date()
	document["loaded"] = true

	if not document.owner_id
		document["owner_id"] = Meteor.userId()
	if not document.visible_to
		document["visible_to"] = "owner"
	if not document.view_order
		document["view_order"] = 1
	if not document.removal_id
		document["removal_id"] = Random.id()
	if not document.template_id
		document["template_id"] = "response"
	if not document.index
		document["index"] = -1
	if not document.parent_id
		document["parent_id"] = ""
	if not document.single_parent
		document["single_parent"] = false
	if not document.group_name
		document["group_name"] = ""

	id = collection.insert document

	return id


#######################################################
@find_documents_paged_unprotected = (collection, filter, mod, parameter) ->
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


###############################################
@find_document = (collection, item_id, owner = true) ->
	check item_id, String

	user = Meteor.user()

	if not user
		throw new Meteor.Error("Not permitted.")

	item = collection.findOne item_id
	if not item
		throw new Meteor.Error("Not permitted.")

	if owner
		if item.owner_id != user._id
			throw new Meteor.Error("Not permitted.")

	return item


#######################################################
@filter_visible_documents = (user_id, restrict={}) ->
	filter = []
	roles = ["all"]

	if restrict.owner_id and user_id
		if restrict.owner_id == user_id
			owner = true

	if user_id
		# find all user roles
		roles.push "anonymous"
		user = Meteor.users.findOne user_id
		roles.push user.roles ...

	if owner
		roles.push 'owner'

	# adding a filter for all elements our current role allows us to see
	filter =
		visible_to:
			$in: roles

	for k,v of restrict
		filter[k] = v

	if not owner
		filter["deleted"] =
			$ne:
				true

	if owner
		filter["owner_id"] = user_id

	return filter


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
@deny_action = (action, collection, item_id, field) ->
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

