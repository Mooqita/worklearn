#######################################################
_upload_dropbox_file = (collection, item_id, field, value, type)->
	access_token: process.env.DROP_BOX_ACCESS_TOKEN
	url = "https://content.dropboxapi.com/2/files/upload"
	path = "/"+collection._name+"/"+item_id+"/"+field+".data"
	arg =
		path: path
		mode:
			".tag":"overwrite"
		autorename: false
		mute: true

	headers =
		Authorization: "Bearer iOPA9EgbtMoAAAAAAAABRPiBDq5HLBx0Ev51nHspVbuVCJLkHSrR0SKzB064F3c7"
		"Content-Type": "application/octet-stream"
		"Dropbox-API-Arg": JSON.stringify arg

	opts =
		content: value
		headers: headers

	res = HTTP.call "POST", url, opts
	return res


#######################################################
@download_dropbox_file = (collection, item_id, field)->
	url = "https://content.dropboxapi.com/2/files/download"
	path =
		path:"/"+collection._name+"/"+item_id+"/"+field+".data"
	access_token: process.env.DROP_BOX_ACCESS_TOKEN

	opts =
		headers:
			Authorization: "Bearer iOPA9EgbtMoAAAAAAAABRPiBDq5HLBx0Ev51nHspVbuVCJLkHSrR0SKzB064F3c7"
			"Dropbox-API-Arg": JSON.stringify path

	res = HTTP.call "POST", url, opts
	if res.statusCode == 200
		msg = "Successfull download: " + path.path
		log_event msg

	return res.content


#######################################################
@upload_file = (collection, item_id, field, value, type) ->
	deny_action_save('modify', collection, item_id, field)
	check value, String

	if value.length > 4*1024*1024
		msg = "File size exceeded by " + Meteor.userId()
		log_event msg, event_db, event_crit #TODO:stack trace.
		throw new Meteor.Error "File size exceeded."

	rng = Math.round Math.random()*100000
	res = _upload_dropbox_file collection, item_id, field, value, type
	modify_field_unprotected collection, item_id, field, rng

	return res


#######################################################
@download_file = (collection, item_id, field) ->
	if not collection
		throw new Meteor.Error "collection undefined"

	item = collection.findOne item_id

	#TODO: implement a more fine grained access control
	if not item.published and item.visible_to != "all"
		deny_action_save 'read', collection, item_id, field

	data = download_dropbox_file collection, item_id, field
	return data


#######################################################
#
#######################################################

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
_download_db_file = (collection, item_id, field)->
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


#######################################################
_upload_db_file = (collection, item_id, field, value, type) ->
	document = collection.findOne item_id

	if not document[field]
		d_id = _add_db_file collection, item_id, field, value, type
	else
		d_id = _modify_db_file collection, item_id, field, value, type

	return d_id

