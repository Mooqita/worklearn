###############################################################################
# Created by Markus on 23/10/2015.
###############################################################################

###############################################################################
_task_map =
	"profiles_resume": "add_document"
	"organizations_description": "add_document"
	"jobs_description": "add_document"
	"jobs_title": "add_document"
	"challenges_title": "add_document"
	"challenges_content": "add_document"
	"profiles_city": ["entity", "place"]
	"profiles_state": ["entity", "place"]
	"profiles_given_name": ["entity", "person"]
	"profiles_middle_name": ["entity", "person"]
	"profiles_family_name": ["entity", "person"]
	"organizations_name": ["entity", "org"]

###############################################################################
class @NLPTask
	constructor: (@payload, @task, @owner_id) ->
		@priority = 0
		@attempts = 0
		@locked_by = null
		@locked_at = null
		@last_error = null
		@created = new Date()


###############################################################################
# collection_name: Name of the collection the text to
#									 analyse can be found.
# item_id: 				 _id of the object that contains
# 								 the text.
# field: 					 the field name of the collection
###############################################################################

###############################################################################
@add_field_to_documents = (collection, item, field, user) ->
	if typeof collection != "string"
		collection = get_collection_name(collection)

	if typeof item != "string"
		item = item._id

	if not item
		throw new Meteor.Error "Item not found."

	if user
		if typeof user != "string"
			user = user._id

	key = (collection + "_" + field)
	task = _task_map[key]

	if not task
		return null

	sub_task = ""
	if typeof task != "string"
		sub_task = task[1]
		task = task[0]

	meta_data =
		sub_taks: sub_task
		collection_name: collection
		item_id: item
		field: field
		owner_id: user

	ds = new @NLPTask(meta_data, task, user)
	set_id = NLPTasks.insert(ds)

	return set_id


###############################################################################
@match_text = (text, hash_id, match_collection, user) ->
	if user
		if typeof user != "string"
			user = user._id

	meta_data =
		text: text
		hash_id: hash_id
		owner_id: user
		match_collection: match_collection

	task = "match_text"

	ds = new NLPTask(meta_data, task, user)
	set_id = NLPTasks.insert(ds)

	return set_id


###############################################################################
@match_document = (collection, item, field, match_collection, user) ->
	if typeof collection != "string"
		collection = get_collection_name(collection)

	if typeof item != "string"
		item = item._id

	if not item
		throw new Meteor.Error "Item not found."

	if user
		if typeof user != "string"
			user = user._id

	meta_data =
		match_collection: match_collection
		collection_name: collection
		item_id: item
		field: field
		owner_id: user

	task = "match_document"

	ds = new NLPTask(meta_data, task, user)
	set_id = NLPTasks.insert(ds)

	return set_id


