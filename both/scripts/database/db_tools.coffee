#######################################################
@get_collection = (collection_name) ->
	collection_name = collection_name.toLowerCase()
	collection = Meteor.Collection.get collection_name
	return collection


#######################################################
_get_filter = (user, role, collection_name, filter) ->
	admission_filter =
		collection_name: collection_name
		consumer_id: user._id
		role: role

	admission_ids = []
	admission_cursor = Admissions.find admission_filter
	admission_cursor.forEach (admission) ->
		admission_ids.add admission.resource_id

	filter["_id"] = {$in: admission_ids}
	return filter


#######################################################
@get_documents = (user, role, collection_name, filter={}, options={}) ->
	filter = _get_filter user, role, collection_name, filter
	collection = get_collection collection_name
	return collection.find filter, options


#######################################################
@get_document = (user, role, collection_name, filter={}, options={}) ->
	filter = _get_filter user, role, collection_name, filter
	collection = get_collection collection_name
	return collection.findOne filter, options


#######################################################
_get_my_filter = (collection_name, filter) ->
	user = Meteor.user()
	filter = _get_filter user, "owner", collection_name, filter
	return filter


#######################################################
@get_my_documents = (collection_name, filter={}, options={}) ->
	filter = _get_my_filter collection_name, filter
	collection = get_collection collection_name
	return collection.find filter, options


#######################################################
@get_my_document = (collection_name, filter={}, options={}) ->
	filter = _get_my_filter collection_name, filter
	collection = get_collection collection_name
	return collection.findOne filter, options


#######################################################
_get_admissary_filter = (collection_name, document_id, role) ->
	admission_filter =
		collection_name: collection_name
		resource_id: document_id
		role: role
	return admission_filter


#######################################################
@get_document_admissaries = (collection_name, document_id, role) ->
	admission_filter = _get_admissary_filter collection_name, document_id, role
	admission_cursor = Admissions.find admission_filter
	return admission_cursor


#######################################################
@get_document_owner = (collection_name, document_id) ->
	admission_filter = _get_admissary_filter collection_name, document_id, role
	admission = Admissions.findOne admission_filter
	return admission

