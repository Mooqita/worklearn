########################################
Template.registerHelper "g_format_date", (date) ->
	day = date.getDate()
	month = date.getMonth() + 1
	year = date.getFullYear()
	str = day + "." + month + "." + year
	return str


########################################
Template.registerHelper "g_debug", (obj, message="") ->
	console.log {data:obj, message:message}


########################################
Template.registerHelper "g_is_public", (collection_name, obj=null) ->
	if typeof obj == "string"
		collection = get_collection collection_name
		data = collection.findOne obj
	else
		data = Template.currentData()

	if not data
		return false

	field_value = get_field_value data, "published", data._id, collection_name
	if not field_value
		return false

	return field_value


########################################
Template.registerHelper "g_is_saved", (collection_name, obj=null) ->
	if typeof obj == "string"
		collection = get_collection collection_name
		data = collection.findOne obj
	else
		data = Template.currentData()

	field_value = get_field_value data, "content", data._id, collection_name

	if not field_value
		return false

	return true


########################################################
Template.registerHelper "g_rating_options", () ->
	opts = [
		{value:"", label:"Select your rating"}
		{value:"1", label:"(1) Needs Improvement"}
		{value:"2", label:"(2) Could be better"}
		{value:"3", label:"(3) Mediocre"}
		{value:"4", label:"(4) Good"}
		{value:"5", label:"(5) Great"}]
	return opts

########################################################
Template.registerHelper "g_value", (data) ->
	context = data.hash
	return get_form_value(context)

