#######################################################
_message_fields =
	fields:
		visible_to: 1
		content: 1
		title: 1
		seen: 1
		url: 1

#######################################################
Meteor.publish "my_messages", () ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	crs = get_my_documents Messages, {}, _message_fields

	log_publication "Messages", crs, filter,
			_message_fields, "my_messages", user_id
	return crs
