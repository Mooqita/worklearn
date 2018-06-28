###############################################################################
# Permissible values for the admission filter function:
#
# collection 		<string> (WILDCARD | IGNORE | group_id | user_id)
# resource_id 	<string> (WILDCARD | IGNORE | resource)
# consumer_id 	<string> (WILDCARD | IGNORE | resource)
# role	 				<string> (IGNORE | role_string)
#
# role_string 	<string> (RECIPIENT | PUBLIC | OWNER | USER)
#
# WILDCARD <string>:
# IGNORE <string>:
#
# resource <string>:
# group_id <string>:
# user_id <string>:
#
#
# Examples:
#
# collection	= WILDCARD
# resource_id			= WILDCARD
# finds all global admissions where resource_id = "*" and collection = "*":
# e.g. if role="admin" then the user has admin rights on all collections.
#
# collection	= IGNORE
# resource_id			= WILDCARD
# finds all admissions resource_id="*"
#
# collection	= WILDCARD
# resource_id			= IGNORE
# finds all admissions for collection="*". Can only be used when either
# user != IGNORE or role != IGNORE
#
# collection	= IGNORE
# resource_id			= IGNORE
# finds all admissions. Can only be used when user != IGNORE
#
# Some more examples with explanations:
# collection, resource_id, user, role
#
# IGNORE, IGNORE, user_id, "admin"
# Find all admissions where the user has the role admin
#
# IGNORE, resource, IGNORE, "admin"
# Find all users with role admin for resource
#
# collection, WILDCARD, IGNORE, "admin"
# Find all users with role admin where collection = collection
# and resource_id="*"
#
###############################################################################

###############################################################################
# filter
###############################################################################

###############################################################################
@_get_admission_filter = (user, role, collection, resource) ->
	check role, String

	if not user
		user = ""

	if typeof collection != "string"
		collection = collection._name

	if typeof resource != "string"
		if not Array.isArray(resource)
			resource = resource._id

	if typeof user != "string"
		user = user._id

	if role == WILDCARD
		msg = "role can not be a WILDCARD. Did you want to use IGNORE?"
		throw new Meteor.Error msg

	if user == WILDCARD
		msg = "user can not be a WILDCARD. Did you want to use IGNORE?"
		throw new Meteor.Error msg

	if role == IGNORE &
		 user == IGNORE &
		 resource == IGNORE &
		 collection == WILDCARD
		msg = "user can be IGNORE only if either user or collection is not set to IGNORE."
		throw new Meteor.Error msg

	if user == IGNORE &
		 resource == IGNORE &
		 collection == IGNORE
		msg = "resource_id can't be IGNORE if user and collection are IGNORE."
		throw new Meteor.Error msg

	admission_filter = {}

	if resource != IGNORE
		if Array.isArray(resource)
			admission_filter["i"] = { $in:resource }
		else
			admission_filter["i"] = resource

	if collection != IGNORE
		admission_filter["c"] = collection

	if user != IGNORE
		admission_filter["u"] = user

	if role != IGNORE
		admission_filter["r"] = role

	return admission_filter


################################################################################
@get_filter = (user, role, collection, filter) ->
	if not filter
		filter = {}

	if user == IGNORE and role == IGNORE
		msg = "user and role set to ignore returning filter"
		log_event msg, event_db, event_warn
		return filter

	if typeof user != "string"
		user = user._id

	admission_filter = _get_admission_filter user, role, collection, IGNORE

	admitted_ids = []
	admission_cursor = Admissions.find admission_filter
	admission_cursor.forEach (admission) ->
		admitted_ids.push admission.i

	if filter._id
		if typeof filter._id == "string"
			restrict = new Set([filter._id])
		else if filter._id.$in
			restrict = new Set(filter._id.$in)
		else
			throw new Meteor.Error "Filter with _id rules are not fully implemented."

	if restrict
		resource_ids = set_union(admitted_ids, restrict)
	else
		resource_ids = admitted_ids

	if not Array.isArray(resource_ids)
		throw new Meteor.Error "Resource ids need to be an array."

	filter["_id"] = {$in: resource_ids}
	return filter


################################################################################
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
		c: 1
		i: 1
		u: 1
		r: 1

################################################################################
@get_admissions = (user, role, collection, resource, options={}) ->
	admission_filter = _get_admission_filter user, role, collection, resource
	admission_cursor = Admissions.find admission_filter, options
	return admission_cursor


################################################################################
@get_admission = (user, role, collection, resource, options={}) ->
	admission_filter = _get_admission_filter user, role, collection, resource
	admission = Admissions.findOne admission_filter, options
	return admission


################################################################################
@get_my_admissions = (role, collection, resource, options={}) ->
	user = Meteor.user()
	admission_cursor = get_admissions user, role, collection, resource, options={}
	return admission_cursor


################################################################################
@get_my_admission = (role, collection, resource, options={}) ->
	user = Meteor.user()
	admission = get_admission user, role, collection, resource, options={}
	return admission


################################################################################
@get_admission_collection_names = () ->
	filter = {}
	mod =
		fields:
			c: 1

	user_id = Meteor.userId()
	if user_id
		filter.u = user_id

	adms = Admissions.find(filter, mod).fetch()
	unique = new Set()

	for a in adms
		unique.add(a.c)

	return unique


###############################################################################
# admissaries
###############################################################################

################################################################################
@get_document_admissaries = (collection, resource, role) ->
	owner_ids = []
	admission_cursor = get_admissions IGNORE, role, collection, resource
	admission_cursor.forEach (admission) ->
		owner_ids.push admission.u

	#filter =
	#	_id:
	#		$in: owner_ids

	#owner_cursor = Meteor.users.find filter
	#return owner_cursor
	return owner_ids


################################################################################
@get_document_owners = (collection, resource) ->
	owner_ids = get_document_admissaries collection, resource, OWNER
	return owner_ids


################################################################################
@get_document_owner = (collection, resource) ->
	admission = get_admission IGNORE, OWNER, collection, resource
	if not admission
		return null

	return admission.u


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


################################################################################
@get_documents = (user, role, collection, filter={}, options={}) ->
	if typeof collection != "string"
		collection = get_collection_name collection

	filter = get_filter user, role, collection, filter
	collection = get_collection collection
	return collection.find filter, options


################################################################################
@get_document = (user, role, collection, filter={}, options={}) ->
	if typeof collection != "string"
		collection = get_collection_name collection

	filter = get_filter user, role, collection, filter
	collection = get_collection collection
	document = collection.findOne filter, options
	return document


################################################################################
@get_my_documents = (collection, filter={}, options={}) ->
	if typeof collection != "string"
		collection = get_collection_name collection

	filter = get_my_filter collection, filter
	collection = get_collection collection
	return collection.find filter, options


################################################################################
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
		if admission.r == role
			has = true
			return

	return has


################################################################################
@get_roles = (user, collection, document) ->
	roles = [PUBLIC]
	admission_cursor = get_admissions user, IGNORE, collection, document
	admission_cursor.forEach (admission) ->
		roles.push admission.r

	if user
		roles.push USER

	return roles


################################################################################
@is_owner = (collection, item, user) ->
	return has_role collection, item, user, OWNER


################################################################################
@has_permission = (collection, item, user, permission) ->
	return has_role collection, item, user, OWNER


################################################################################
@can_set_permission = (collection, item, user) ->
	return has_role collection, item, user, OWNER


################################################################################
@can_edit = (collection, item, user) ->
	return has_role collection, item, user, OWNER


################################################################################
@can_view = (collection, item, user) ->
	return has_role collection, item, user, OWNER


