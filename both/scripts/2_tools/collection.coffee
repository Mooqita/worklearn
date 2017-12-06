#######################################################
@get_collection = (collection_name) ->
	collection_name = collection_name.toLowerCase()
	collection = Meteor.Collection.get collection_name
	return collection


