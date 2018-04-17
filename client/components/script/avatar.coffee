###############################################################################
# Avatar
###############################################################################

###############################################################################
Template.avatar.helpers
	is_downloading: () ->
		inst = Template.instance()
		data  = inst.data
		collection_name = data.collection_name
		item_id = data.item_id
		field = data.field

		key = collection_name + item_id + field
		download_object = Session.get key

		if download_object
			return true

		return false



