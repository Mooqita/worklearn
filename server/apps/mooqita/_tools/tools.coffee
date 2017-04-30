###############################################
@secure_item_action = (item_id, type, owner = true) ->
	user = Meteor.user()

	if not user
		throw new Meteor.Error("Not permitted.")

	item = Responses.findOne item_id
	if not item
		throw new Meteor.Error("Not permitted.")

	if item.type_identifier != type
		throw new Meteor.Error("Not a " + type + ": " + item.type_identifier)

	if owner
		if item.owner_id != user._id
			throw new Meteor.Error("Not permitted.")

	return item


