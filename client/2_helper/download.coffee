###############################################################################
# download
###############################################################################

###############################################################################
Template.registerHelper "g_download_field_value", (collection_name, item_id, field, observe) ->
	value = get_field_value null, field, item_id, collection_name

	if value
		if value.length > 32
			return value

	key = collection_name + item_id + field
	download_object = Session.get key

	_download = () ->
		Meteor.call "download_file", collection_name, item_id, field,
			(err, res) ->
				if err
					sAlert.error "Download helper error: " + err
					console.log err
				else
					d_o =
						rng: get_field_value null, field, item_id, collection_name
						data: res
					Session.set key, d_o

	if download_object
		if observe
			if download_object.rng != observe
				_download()
		if download_object.data
			return download_object.data
	else
		d_o =
			rng: get_field_value null, field, item_id, collection_name
			data: null
		Session.set key, d_o

		_download()

	return ""
