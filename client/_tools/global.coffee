#######################################################
@find_response_names = (collection_name) ->
	collection = get_collection collection_name

	tmpls = [{value:"", label:"Select response"}]

	d_tmpls = collection.find().fetch()
	d_tmpls = ({label:t.title, value:t._id} for t in d_tmpls)

	tmpls.push d_tmpls...

	return tmpls


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
	profile = Profiles.findOne filter

	return profile


#######################################################
@get_field_value = (self, field, item_id, collection_name) ->
	#TODO: replace collection_name with collection object if possible to enhance consistency

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


#######################################################
@how_much_time = (mls) ->
	sec = 1000
	min = sec*60
	hrs = min*60
	day = hrs*24
	days = mls / day
	if days < 0.75
		return "less than a day"

	if days < 3
		return "with in a few days"

	if days < 7
		return "within a week"

	return "more than a week"

