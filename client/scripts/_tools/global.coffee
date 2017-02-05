Template.registerHelper "can_edit_post", (item_id, required_role) ->
	has_role = Roles.userIsInRole(Meteor.user(), [required_role])
	item = Posts.findOne(item_id)
	owns = item.owner_id == Meteor.userId()
	return has_role && owns
