#######################################################
@get_collection = (collection_name) ->
	collection_name = collection_name.toLowerCase()
	collection = Meteor.Collection.get collection_name
	return collection


#######################################################
@get_collection_name = (collection) ->
	if typeof collection == "string"
		c_test = get_collection(collection)
		if not c_test
			throw new Meteor.Error("Collection is not valid: " + collection)

		return collection

	collection_name = collection._name
	if not collection_name
		throw new Meteor.Error("Collection is not valid: " + collection)

	return collection_name


