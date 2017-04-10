################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	set_field: (collection, item_id, field, data)->
		return modify_field collection, item_id, field, data

	upload_file: (collection, item_id, field, data, type)->
		return upload_file collection, item_id, field, data, type

	download_file: (collection, item_id, field)->
		return download_file collection, item_id, field


