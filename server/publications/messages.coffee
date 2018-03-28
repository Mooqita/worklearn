#######################################################
_message_fields =
	fields:
		content: 1
		title: 1
		seen: 1
		url: 1

#######################################################
Meteor.publish "my_messages", (parameter) ->
	pattern =
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter = get_my_filter Messages, {}
	crs = get_documents_paged_unprotected Messages, filter, _message_fields, parameter

	log_publication crs, user_id, "my_messages"
	return crs
