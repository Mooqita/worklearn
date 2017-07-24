#######################################################
_message_fields =
	fields:
		visible_to: 1
		owner_id: 1
		content: 1
		title: 1
		seen: 1
		url: 1

#######################################################
Meteor.publish "my_messages", () ->
	user_id = this.userId
	restrict =
		owner_id: user_id

	filter = filter_visible_documents user_id, restrict
	crs = Messages.find filter, _message_fields

	log_publication "Messages", crs, filter,
			_message_fields, "my_messages", user_id
	return crs
