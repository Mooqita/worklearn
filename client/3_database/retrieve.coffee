#######################################################
@get_field_value = (self, field, item_id, collection_name) ->
	#TODO: replace collection_name with collection object if possible to enhance consistency
	if self
		collection_name = collection_name || self.collection_name
		item_id = item_id || self.item_id
		field = field || self.field

	if not collection_name
		console.log "collection_name is undefined"
		return undefined

	if not item_id = item_id
		console.log "item_id is undefined"
		return undefined

	if not field = field
		console.log "field is undefined"
		return undefined

	if item_id == -1
		return undefined

	collection = get_collection(collection_name)
	if not collection
		console.log "collection not found: " + collection_name
		return undefined

	item = collection.findOne(item_id)
	if not item
		console.log "item: (" + item_id + ") not found in: " + collection_name
		return undefined

	return item[field]
