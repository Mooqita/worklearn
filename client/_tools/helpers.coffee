########################################
Template.registerHelper "_profile", () ->
	return get_profile()

########################################
Template.registerHelper "_debug", (obj) ->
	console.log obj

########################################
Template.registerHelper "current_data", () ->
	data = 	Session.get "current_data"
	self = Template.instance().data
	res = if data then data else self
	return res

########################################
Template.registerHelper "selected_view", () ->
	selected = Session.get "current_template"
	return selected

########################################
Template.registerHelper "download_field_value", (collection_name, item_id, field, observe) ->
	key = collection_name + item_id + field
	value = get_field_value null, field, item_id, collection_name

	if value
		if value.length>32
			return value

	value = Session.get key

	download = () ->
		Meteor.call "download_file", collection_name, item_id, field,
		(err, res) ->
			if err
				sAlert.error(err)
			else
				Session.set key, res.data

	if not value
		Session.set key, "___empty___"
		download()

	if value != "___empty___"
		return value

	return ""


########################################
Template.registerHelper "_is_owner", (obj) ->
	if typeof obj == "string"
		obj = Responses.findOne obj

	owner = obj.owner_id == Meteor.userId()
	return owner


########################################
Template.registerHelper "_is_public", (obj=null) ->
	if typeof obj == "string"
		data = Responses.findOne obj
	else
		data = Template.currentData()

	field_value = get_field_value data, "visible_to", data._id, "Responses"

	if not field_value
		return false

	return field_value == "anonymous"


########################################
Template.registerHelper "_is_saved", () ->
	data = Template.currentData()
	field_value = get_field_value data, "content", data._id, "Responses"
	if not field_value
		return false
	return true


########################################
Template.registerHelper "_response_url", (_id) ->
	return get_response_url _id, true


#######################################################
Template.registerHelper "_response_visibility", () ->
	opts = [
		{value:"", label:"Who can read your post"}
		{value:"all", label:"Everyone"}
		{value:"anonymous", label:"Registered Users"}
		{value:"owner", label:"Only me"}]
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
Template.registerHelper "_can_edit_response", (item_id) ->
	item = Responses.findOne(item_id)
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
