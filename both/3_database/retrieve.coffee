###############################################################################

###############################################################################
# Acceptable values for the admission filter function
#
# collection_name		resource_id		consumer_id		role
# group_id					String				document_id		String
# user_id						X							X							X
#	WILDCARD					WILDCARD			X							X
# IGNORE						IGNORE				IGNORE				IGNORE
#
# Additional limitations: resource_id, collection_name
#
# WILDCARD, WILDCARD:
# finds all global admissions where resource_id = "*" and collection_name = "*":
# e.g. if role="admin" then the user has admin rights on all collections.
#
# WILDCARD, IGNORE:
# finds all admissions resource_id="*"
#
# IGNORE, WILDCARD:
# finds all admissions for collection_name="*". Can only be used when either
# consumer_id != IGNORE or role != IGNORE
#
# IGNORE, IGNORE:
# finds all admissions. Can only be used when consumer_id != IGNORE
#
# Some more examples with explanations:
# collection_name, resource_id, consumer_id, role
#
# IGNORE, IGNORE, user_id, "admin"
# Find all admissions where the user has the role admin
#
# IGNORE, document_id, IGNORE, "admin"
# Find all users with role admin for document_id
#
# collection_name, WILDCARD, IGNORE, "admin"
# Find all users with role admin where collection_name = collection_name
# and resource_id="*"
#
###############################################################################

###############################################################################
# filter
###############################################################################

###############################################################################
@_get_admission_filter = (collection_name, document_id, consumer_id, role) ->
	check role, String

	if consumer_id == null
		consumer_id = ""

	if typeof collection_name != "string"
		collection_name = collection_name._name

	if typeof document_id != "string"
		document_id = document_id._id

	if typeof consumer_id != "string"
		consumer_id = consumer_id._id

	if role == WILDCARD
		msg = "role can not be a WILDCARD. Did you want to use IGNORE?"
		throw new Meteor.Error msg

	if consumer_id == WILDCARD
		msg = "consumer_id can not be a WILDCARD. Did you want to use IGNORE?"
		throw new Meteor.Error msg

	if role == IGNORE &
		 consumer_id == IGNORE &
		 document_id == IGNORE &
		 collection_name == WILDCARD
		msg = "consumer_id can be IGNORE only if either consumer_id or collection_name is not set to IGNORE."
		throw new Meteor.Error msg

	if consumer_id == IGNORE &
		 document_id == IGNORE &
		 collection_name == IGNORE
		msg = "resource_id can't be IGNORE if consumer_id and collection_name are IGNORE."
		throw new Meteor.Error msg

	admission_filter = {}

	if document_id != IGNORE
		admission_filter["resource_id"] = document_id

	if collection_name != IGNORE
		admission_filter["collection_name"] = collection_name

	if consumer_id != IGNORE
		admission_filter["consumer_id"] = consumer_id

	if role != IGNORE
		admission_filter["role"] = role

	return admission_filter


#######################################################
_union = (a, b)->
	res = []
	for x in a
		if b.has(x)
			res.push(x)
	return res

@get_filter = (user, role, collection_name, filter) ->
	if not filter
		filter = {}

	if user == IGNORE and role == IGNORE
		msg = "user and role set to ignore returning filter"
		log_event msg, event_db, event_warn
		return filter

	admission_filter = _get_admission_filter collection_name, IGNORE, user, role

	admitted_ids = []
	admission_cursor = Admissions.find admission_filter
	admission_cursor.forEach (admission) ->
		admitted_ids.push admission.resource_id

	if filter._id
		if typeof filter._id == "string"
			restrict = new Set([filter._id])
		else if filter._id.$in
			restrict = new Set(filter._id.$in)
		else
			throw new Meteor.Error "Filter with _id rules are not fully implemented."

	if restrict
		resource_ids = _union(admitted_ids, restrict)
	else
		resource_ids = admitted_ids

	if not Array.isArray(resource_ids)
		throw new Meteor.Error "Resource ids need to be an array."

	filter["_id"] = {$in: resource_ids}
	return filter


#######################################################
@get_my_filter = (collection, filter) ->
	user = Meteor.user()
	filter = get_filter user, OWNER, collection, filter
	return filter


###############################################################################
# admissions
###############################################################################

###############################################################################
_admission_fields =
	fields:
		collection_name: 1
		resource_id: 1
		consumer_id: 1
		role: 1


#######################################################
@get_admissions = (user, role, collection, resource, options={}) ->
	admission_filter = _get_admission_filter collection, resource, user, role
	admission_cursor = Admissions.find admission_filter, options
	return admission_cursor


#######################################################
@get_admission = (user, role, collection, resource, options={}) ->
	admission_filter = _get_admission_filter collection, resource, user, role
	admission = Admissions.findOne admission_filter, options
	return admission


#######################################################
@get_my_admissions = (role, collection, resource, options={}) ->
	user = Meteor.user()
	admission_cursor = get_admissions user, role, collection, resource, options={}
	return admission_cursor


#######################################################
@get_my_admission = (role, collection, resource, options={}) ->
	user = Meteor.user()
	admission = get_admission user, role, collection, resource, options={}
	return admission


###############################################################################
# admissaries
###############################################################################

#######################################################
@get_document_admissaries = (collection, document_id, role) ->
	owner_ids = []
	admission_cursor = get_admissions IGNORE, role, collection, document_id
	admission_cursor.forEach (admission) ->
		owner_ids.push admission.consumer_id

	filter["_id"] = {$in: owner_ids}
	owner_cursor = Meteor.users.find filter
	return owner_cursor


#######################################################
@get_document_owners = (collection, document_id) ->
	owner_cursor = get_document_admissaries collection, document_id, OWNER
	return owner_cursor


#######################################################
@get_document_owner = (collection, document_id) ->
	admission = get_admission IGNORE, OWNER, collection, document_id
	if not admission
		return null

	user = Meteor.users.findOne(admission.consumer_id)
	return user


###############################################################################
# documents
###############################################################################

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
@get_documents = (user, role, collection, filter={}, options={}) ->
	if typeof collection != "string"
		collection = get_collection_name collection

	filter = get_filter user, role, collection, filter
	collection = get_collection collection
	return collection.find filter, options


#######################################################
@get_document = (user, role, collection, filter={}, options={}) ->
	if typeof collection != "string"
		collection = get_collection_name collection

	filter = get_filter user, role, collection, filter
	collection = get_collection collection
	document = collection.findOne filter, options
	return document


#######################################################
@get_my_documents = (collection, filter={}, options={}) ->
	if typeof collection != "string"
		collection = get_collection_name collection

	filter = get_my_filter collection, filter
	collection = get_collection collection
	return collection.find filter, options


#######################################################
@get_my_document = (collection, filter={}, options={}) ->
	if typeof collection != "string"
		collection = get_collection_name collection

	filter = get_my_filter collection, filter
	collection = get_collection collection
	return collection.findOne filter, options


###############################################################################
# roles and permissions
###############################################################################

########################################
@has_role = (collection, document, user, role) ->
	has = false
	admission_cursor = get_admissions user, IGNORE, collection, document
	admission_cursor.forEach (admission) ->
		if admission.role == role
			has = true
			return

	return has


#######################################################
@get_roles = (user, collection, document) ->
	roles = [PUBLIC]
	admission_cursor = get_admissions user, IGNORE, collection, document
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


