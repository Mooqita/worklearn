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


#######################################################
@remove_documents = (collection, filter, user) ->
	if typeof collection == "string"
		collection = get_collection(collection)

	mod =
		fields:
			_id: 1

	items = collection.find(filter, mod).fetch()
	ids = (i._id for i in items)

	remove_admissions(collection, ids, user)

	count = collection.remove filter
	msg = count + " admissions removed by: " + get_user_mail()
	log_event msg, event_db, event_info

	return count


