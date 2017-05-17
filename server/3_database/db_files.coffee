#######################################################
_add_db_file = (collection, item_id, field, value, type)->
	mime = require('mime');
	extension = mime.extension(type)

	file =
		data: value
		field: field
		owner: Meteor.userId()
		item_id: item_id
		encoding: "base64"
		file_type: type
		extension: extension
		collection_name: collection._name

	d_id = store_document DBFiles, file

	return d_id

#######################################################
_modify_db_file = (collection, item_id, field, value, type)->
	filter =
		field: field
		item_id: item_id
		owner_id: Meteor.userId()
		collection_name: collection._name

	mod =
		fields:
			_id:1

	dead = DBFiles.findOne(filter, mod)

	n_id = _add_db_file collection, item_id, field, value, type

	if dead
		DBFiles.remove dead._id

	return n_id

#######################################################
@upload_file = (collection, item_id, field, value, type) ->
	deny_action_save('modify', collection, item_id, field)

	check value, String

	document = collection.findOne item_id

	if not document[field]
		d_id = _add_db_file collection, item_id, field, value, type
	else
		d_id = _modify_db_file collection, item_id, field, value, type

	modify_field_unprotected collection, item_id, field, d_id
	return d_id


#######################################################
@download_file = (collection, item_id, field) ->
	if not collection
		throw new Meteor.Error "collection undefined"

	item = collection.findOne item_id

	#TODO: implement a more fine grained access control
	if not item.published and item.visible_to != "all"
		deny_action_save('read', collection, item_id, field)

	return download_file_unprotected collection, item_id, field


#######################################################
@download_file_unprotected = (collection, item_id, field) ->
	filter =
		item_id: item_id
		field: field
		collection_name: collection._name

	mod =
		fields:
			data: 1
			type: 1
			encoding: 1
			extension: 1

	crs = DBFiles.findOne filter, mod
	found = if crs then "Found " else "Not found "
	msg = found + collection._name + " " + item_id + " " + field + " server side download"
	log_event msg, event_file, event_info

	crs = if crs then crs else {error:"not found"}
	return crs