#######################################################
#
#Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
@Secrets = new Mongo.Collection("secrets")
@Logging = new Mongo.Collection("logging")
@DBFiles = new Mongo.Collection("dbfiles")

#######################################################
@get_collection = (collection_name) ->
	collection = this[collection_name]
	if not collection instanceof Meteor.Collection
		return undefined

	return collection
