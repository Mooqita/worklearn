########################################
Template.registerHelper 'formatDate', (date) ->
	day = date.getDate()
	month = date.getMonth() + 1
	year = date.getFullYear()
	str = day + "." + month + "." + year
	return str


########################################
Template.registerHelper "_profile", () ->
	return get_profile()

########################################
Template.registerHelper "_debug", (obj, message="") ->
	console.log {data:obj, message:message}

########################################
Template.registerHelper "_selected_view", () ->
	return get_selected_view()

########################################
# download
########################################

########################################
Template.registerHelper "download_field_value", (collection_name, item_id, field, observe) ->
	value = get_field_value null, field, item_id, collection_name

	if value
		if value.length > 32
			return value

	key = collection_name + item_id + field
	download_object = Session.get key

	_download = () ->
		Meteor.call "download_file", collection_name, item_id, field,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					d_o =
						rng: get_field_value null, field, item_id, collection_name
						data: res
					Session.set key, d_o

	if download_object
		if download_object.rng != observe
			_download()
		if download_object.data
			return download_object.data
	else
		_download()

	return ""

########################################
Template.registerHelper "_is_owner", (collection_name, obj) ->
	if typeof obj == "string"
		collection = get_collection collection_name
		obj = collection.findOne obj

	owner = obj.owner_id == Meteor.userId()
	return owner


########################################
Template.registerHelper "_is_public", (collection_name, obj=null) ->
	if typeof obj == "string"
		collection = get_collection collection_name
		data = collection.findOne obj
	else
		data = Template.currentData()

	field_value = get_field_value data, "published", data._id, collection_name

	if not field_value
		return false

	return field_value


########################################
Template.registerHelper "_is_saved", (collection_name, obj=null) ->
	if typeof obj == "string"
		collection = get_collection collection_name
		data = collection.findOne obj
	else
		data = Template.currentData()

	field_value = get_field_value data, "content", data._id, collection_name

	if not field_value
		return false

	return true


#######################################################
Template.registerHelper "_response_visibility", () ->
	opts = [
		{value:"", label:"Who can read your post"}
		{value:"all", label:"Everyone"}
		{value:"anonymous", label:"Registered Users"}
		{value:"editor", label:"Editors"}]
	return opts

#######################################################
Template.registerHelper "_rating_options", () ->
	opts = [
		{value:"", label:"Select your rating"}
		{value:"1", label:"(1) Needs Improvement"}
		{value:"2", label:"(2) Could be better"}
		{value:"3", label:"(3) Mediocre"}
		{value:"4", label:"(4) Good"}
		{value:"5", label:"(5) Great"}]
	return opts


#######################################################
Template.registerHelper "_is_fullscreen", () ->
	return Session.get "full_screen"

#######################################################
Template.registerHelper "_can_edit_template", (item_id, required_role) ->
	has_role = Roles.userIsInRole(Meteor.user(), [required_role])
	item = Templates.findOne(item_id)
	owns = item.owner_id == Meteor.userId()
	return has_role && owns

#######################################################
Template.registerHelper "_is_editing_template", (item_id) ->
	is_ed = item_id == Session.get("editing_template")
	return is_ed

#######################################################
Template.registerHelper "_can_edit_response", (collection_name, item_id) ->
	collection = get_collection collection_name
	item = collection.findOne(item_id)
	owns = item.owner_id == Meteor.userId()
	editor = Roles.userIsInRole Meteor.userId(), "editor"
	return owns or editor

#######################################################
Template.registerHelper "_is_editing_response", (item_id) ->
	is_ed = item_id == Session.get("editing_response")
	return is_ed

#######################################################
Template.registerHelper "_is_editing", () ->
	if not Session.get("editing_response")
		return false

	return true

#######################################################
# This allows us to write inline objects in Blaze templates
# like so: {{> template param=(object key="value") }}
# => The template"s data context will look like this:
# { param: { key: "value" } }
Template.registerHelper "object", (param) ->
	return param.hash

#######################################################
# This allows us to write inline arrays in Blaze templates
# like so: {{> template param=(array 1 2 3) }}
# => The template"s data context will look like this:
# { param: [1, 2, 3] }
Template.registerHelper "array", (param...) ->
	return param.slice 0, param.length-1
