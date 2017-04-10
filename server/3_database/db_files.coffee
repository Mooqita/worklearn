#######################################################
_add_db_file = (collection_name, item_id, field, value, type)->
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
		collection_name: collection_name

	res = save_document DBFiles, file
	return res

#######################################################
_modify_db_file = (collection_name, item_id, field, value, type)->
	filter =
		field: field
		item_id: item_id
		owner_id: Meteor.userId()
		collection_name: collection_name

	mod =
		$set:
			data: value
			file_type: type

	res = DBFiles.update filter, mod
	return res

#######################################################
@upload_file = (collection_name, item_id, field, value, type) ->
	deny_action_save('modify', collection_name, item_id, field)

	check value, String

	collection = get_collection collection_name
	document = collection.findOne item_id

	if not document[field]
		d_id = _add_db_file collection_name, item_id, field, value, type
		modify_field_unprotected(collection_name, item_id, field, d_id)
	else
		d_id = _modify_db_file collection_name, item_id, field, value, type

	return d_id

#######################################################
@download_file = (collection_name, item_id, field) ->
	deny_action_save('read', collection_name, item_id, field)

	filter =
		item_id: item_id
		field: field
		collection_name: collection_name

	mod =
		fields:
			data: 1
			type: 1
			encoding: 1
			extension: 1

	res = DBFiles.findOne filter, mod
	return res