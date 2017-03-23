#######################################################
Template.registerHelper "_response_visibility", () ->
	opts = [
		{value:"", label:"Who can read your post"}
		{value:"all", label:"Everyone"}
		{value:"anonymous", label:"Registered Users"}
		{value:"owner", label:"Only me"}]
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

	return owns

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
