#######################################################
#
#Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
@Permissions = new Mongo.Collection("permissions")
@Secrets = new Mongo.Collection("secrets")
@DBFiles = new Mongo.Collection("dbfiles")

#######################################################
@get_collection = (collection_name) ->
	collection = this[collection_name]
	if not collection instanceof Meteor.Collection
		return undefined

	return collection
