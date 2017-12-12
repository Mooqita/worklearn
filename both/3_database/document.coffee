#######################################################
_get_filter = (user_id, role, collection_name, filter) ->
	if not role
		throw new Meteor.Error('Role not defined')

	if typeof user_id != "string"
		user_id = user_id._id

	if typeof collection_name != "string"
		collection_name = collection_name._name

	if not collection_name
		throw new Meteor.Error('Collection not defined')

	if not user
		throw new Meteor.Error('User not found')

	admission_filter =
		collection_name: collection_name
		consumer_id: user_id

	if role != WILDCARD
		admission_filter["role"] = role


	admission_ids = []
	admission_cursor = Admissions.find admission_filter
	admission_cursor.forEach (admission) ->
		admission_ids.add admission.resource_id

	filter["_id"] = {$in: admission_ids}
	return filter


#######################################################
_get_my_filter = (collection_name, filter) ->
	user = Meteor.user()
	filter = _get_filter user, OWNER, collection_name, filter
	return filter


#######################################################
_get_admissary_filter = (collection_name, document_id, role) ->
	if not role
		throw new Meteor.Error('Role not defined')

	if not collection_name
		throw new Meteor.Error('Collection_name not defined')

	if typeof collection_name != "string"
		collection_name = collection_name._name

	if typeof document_id != "string"
		document_id = document_id._id

	admission_filter =
		collection_name: collection_name
		resource_id: document_id

	if role != WILDCARD
		admission_filter["role"] = role

	return admission_filter


#######################################################
@get_documents = (user, role, collection_name, filter={}, options={}) ->
	if typeof collection_name != "string"
		collection_name = collection_name._name

	filter = _get_filter user, role, collection_name, filter
	return collection.find filter, options


#######################################################
@get_document = (user, role, collection_name, filter={}, options={}) ->
	if typeof collection_name != "string"
		collection_name = collection_name._name

	filter = _get_filter user, role, collection_name, filter
	collection = get_collection collection_name
	return collection.findOne filter, options


###############################################
@get_document_unprotected = (collection, item_id) ->
	check item_id, String

	user = Meteor.user()

	if not user
		throw new Meteor.Error("Not permitted.")

	if typeof collection is "string"
		collection = get_collection collection

	item = collection.findOne item_id
	if not item
		throw new Meteor.Error("Not permitted.")

	return item


#######################################################
@get_my_documents = (collection_name, filter={}, options={}) ->
	if typeof collection_name != "string"
		collection_name = collection_name._name

	filter = _get_my_filter collection_name, filter
	collection = get_collection collection_name
	return collection.find filter, options


#######################################################
@get_my_document = (collection_name, filter={}, options={}) ->
	if typeof collection_name != "string"
		collection_name = collection_name._name

	filter = _get_my_filter collection_name, filter
	collection = get_collection collection_name
	return collection.findOne filter, options


#######################################################
@get_document_admissaries = (collection_name, document_id, role) ->
	admission_filter = _get_admissary_filter collection_name, document_id, role
	admission_cursor = Admissions.find admission_filter
	return admission_cursor


#######################################################
@get_document_owner = (collection_name, document_id) ->
	admission_cursor = get_document_admissaries collection_name, document_id, OWNER
	admission_cursor.forEach (admission) ->
		return Meteor.users.findOne(admission.consumer_id)


#######################################################
@get_document_owners = (collection_name, document_id) ->
	owner_ids = []
	admission_cursor = get_document_admissaries collection_name, document_id, OWNER
	admission_cursor.forEach (admission) ->
		owner_ids.push admission.consumer_id

	filter["_id"] = {$in: owner_ids}
	owner_cursor = Meteor.users.find filter
	return owner_cursor


########################################
@has_role = (collection, item, user, role) ->
	if typeof collection == "string"
		collection = get_collection collection
		collection_name = collection._name
	else
		collection_name = collection._name

	if typeof item == "string"
		item = collection.findOne(item)

	if not item._id
		throw new Meteor.Error('Not permitted.')

	if typeof user == "string"
		user = Meteor.users.findOne(user)

	if not user._id
		throw new Meteor.Error('Not permitted.')

	admission_cursor = get_document_admissaries collection, item, role
	admission_cursor.forEach (admission) ->
		if admission.consumer_id == user._id
			return true

	return false


#######################################################
@get_roles = (collection_name, document, user) ->
	roles = [PUBLIC]
	admission_cursor = get_document_admissaries collection_name, document, WILDCARD
	admission_cursor.forEach (admission) ->
		roles.push admission.role

	if user
		roles.push USER

	return roles


########################################
@is_owner = (collection, item, user) ->
	return has_role collection, item, user, OWNER


########################################
@has_permission = (collection, item, user, permission) ->
	return has_role collection, item, user, OWNER


########################################
@can_set_permission = (collection, item, user) ->
	return has_role collection, item, user, OWNER


########################################
@can_edit = (collection, item, user) ->
	return has_role collection, item, user, OWNER


########################################
@can_view = (collection, item, user) ->
	return has_role collection, item, user, OWNER


