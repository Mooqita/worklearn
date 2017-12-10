#######################################################
name_from_url = (url, name_only = false) ->
	regex = /^(?:((?:https?|s?ftp):)\/\/)([^:\/\s]+)(?::(\d*))?(?:\/([^\s?#]+)?([?][^?#]*)?(#.*)?)?/
	res = regex.exec url

	return res[2]


#######################################################
_upload_dropbox_file = (collection, item_id, field, value, type)->
	access_token = process.env.DROP_BOX_ACCESS_TOKEN
	url = "https://content.dropboxapi.com/2/files/upload"
	path = "/"+collection._name+"/"+item_id+"/"+field+".data"
	origin = name_from_url process.env.ROOT_URL, true

	if origin == "localhost"
		path = "/_" + origin + path

	arg =
		path: path
		mode:
			".tag":"overwrite"
		autorename: false
		mute: true

	headers =
		Authorization: access_token
		"Content-Type": "application/octet-stream"
		"Dropbox-API-Arg": JSON.stringify arg

	opts =
		content: value
		headers: headers

	res = HTTP.call "POST", url, opts
	return res


#######################################################
@download_dropbox_file = (collection, item_id, field)->
	check item_id, String
	check field, String

	access_token = process.env.DROP_BOX_ACCESS_TOKEN
	url = "https://content.dropboxapi.com/2/files/download"
	path = "/"+collection._name+"/"+item_id+"/"+field+".data"
	origin = name_from_url process.env.ROOT_URL, true

	if origin == "localhost"
		path = "/_" + origin + path

	path =
		path: path

	opts =
		headers:
			Authorization: access_token
			"Dropbox-API-Arg": JSON.stringify path

	try
		res = HTTP.call "POST", url, opts
		if res.statusCode == 200
			msg = "Successfull download: " + path.path
			log_event event_file, msg
		else
			msg = "Download error for path: " + path.path + " : " + res.error
			log_event msg, event_file, event_err
	catch e
		msg = "Download throw exception for path: " + path.path + " : " + e
		log_event msg, event_file, event_err

	if res
		return res.content

	return null


#######################################################
@upload_file = (collection, item_id, field, value, type) ->
	deny_action('modify', collection, item_id, field)
	check value, String

	if value.length > 10*1024*1024
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
	if not item
		throw new Meteor.Error "not permitted"

	#TODO: implement fine grained access control
	# if not item.published and item.visible_to != "all"
	#	deny_action_save 'read', collection, item_id, field

	data = download_dropbox_file collection, item_id, field
	return data
