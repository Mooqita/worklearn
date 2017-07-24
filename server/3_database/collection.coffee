#######################################################
#
# Created by Markus
#
#######################################################

#######################################################
@get_collection_save = (collection_name) ->
	check collection_name, String
	collection = get_collection collection_name

	if not collection
		throw new Meteor.Error "Collection not found: " + collection_name

	return collection


#######################################################
@backup_collection = (collection_name) ->
	collection = get_collection_save collection_name
	data = export_data(collection)
	return data