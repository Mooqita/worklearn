#######################################################
@get_field_value = (self, field, item_id, collection_name) ->
	collection_name = collection_name || self.collection_name
	item_id = item_id || self.item_id
	field = field || self.item_id

	collection = global[collection_name]
	if not collection
		return undefined

	item = collection.findOne(item_id)
	if not item
		return undefined

	return item[field]

#######################################################
Template.registerHelper "can_edit_post", (item_id, required_role) ->
	has_role = Roles.userIsInRole(Meteor.user(), [required_role])
	item = Posts.findOne(item_id)
	owns = item.owner_id == Meteor.userId()
	return has_role && owns

#######################################################
Template.registerHelper "is_editing", (item_id) ->
	is_ed = item_id == Session.get("editing_post")
	return is_ed

#######################################################
Template.registerHelper "editing", () ->
	return Session.get("editing_post")

#######################################################
# This allows us to write inline objects in Blaze templates
# like so: {{> template param=(object key="value") }}
# => The template's data context will look like this:
# { param: { key: "value" } }
Template.registerHelper 'object', (param) ->
	return param.hash

#######################################################
# This allows us to write inline arrays in Blaze templates
# like so: {{> template param=(array 1 2 3) }}
# => The template's data context will look like this:
# { param: [1, 2, 3] }
Template.registerHelper 'array', (param...) ->
	return param.slice 0, param.length-1