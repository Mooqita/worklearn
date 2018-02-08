#######################################################
#
# Created by Markus
#
#######################################################

#######################################################
@store_document_unprotected = (collection, document, owner, admission)->
	document["created"] = new Date()
	document["modified"] = new Date()

	id = collection.insert document
	item = collection.findOne id

	if not owner
		return id

	if not admission
		return id

	collection_name = get_collection_name collection
	gen_admission collection_name, item, owner, OWNER

	return id


