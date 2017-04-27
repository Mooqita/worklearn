##############################################
@get_selected_view = () ->
	selected = FlowRouter.getQueryParam("template")

	if not selected
		selected = "landing_page"

	return selected


##############################################
@get_profile = () ->
	user_id = Meteor.userId()
	filter =
		owner_id: user_id
		type_identifier: "profile"
	profile = Responses.findOne filter

	return profile


#######################################################
@find_response_names = () ->
	tmpls = [{value:"", label:"Select response"}]

	d_tmpls = Responses.find().fetch()
	d_tmpls = ({label:t.title, value:t._id} for t in d_tmpls)

	tmpls.push d_tmpls...

	return tmpls

#######################################################
@get_field_value = (self, field, item_id, collection_name) ->
	collection_name = collection_name || self.collection_name
	item_id = item_id || self.item_id
	field = field || self.field

	collection = global[collection_name]
	if not collection
		console.log "collection not found: " + collection_name
		return undefined

	item = collection.findOne(item_id)
	if not item
		console.log "item: (" + item_id + ") not found in: " + collection_name
		return undefined

	return item[field]
