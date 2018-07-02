###############################################################################
#
# Bas input functions
#
###############################################################################

###############################################################################
@get_form_value = (context) ->
	if context.session
		value = Session.get context.session
		if context.key
			if not value
				Session.set(context.session, {})
				value = Session.get(context.session)
			value = value[context.key]
	else if context.variable
		data = context.variable
		value = data.get()
	else if context.dictionary
		data = context.dictionary
		value = data.get context.key
	else if context.collection_name
		value = get_field_value context

	return value


###############################################################################
@set_form_value = (context, value) ->
	if context.session
		if context.key
			dict = Session.get context.session
			if not dict
				dict = {}
			dict[context.key] = value
			value = dict
		Session.set context.session, value
	else if context.variable
		variable = context.variable
		variable.set value
	else if context.dictionary
		dict = context.dictionary
		if not dict
			console.log("Missing dictionary")
		key = context.data.key
		dict.set key, value
	else if context.collection_name
		cn = context.collection_name
		f = context.field
		id = context.item_id
		set_field cn, id, f, value


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

	if not item_id
		console.log "item_id is undefined"
		return undefined

	if not field
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
