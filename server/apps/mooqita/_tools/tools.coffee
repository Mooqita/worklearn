###############################################
@secure_item_action = (collection, item_id, owner = true) ->
	user = Meteor.user()

	if not user
		throw new Meteor.Error("Not permitted.")

	item = collection.findOne item_id
	if not item
		throw new Meteor.Error("Not permitted.")

	if owner
		if item.owner_id != user._id
			throw new Meteor.Error("Not permitted.")

	return item


