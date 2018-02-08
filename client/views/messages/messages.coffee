#######################################################
Template.messages.helpers
	messages: () ->
		mod =
			sort:
				seen: 1
				title: 1

		return get_my_documents "messages", {}, mod


#######################################################
Template.message_preview.events
	"click #message": ->
		set_field Messages, this._id, "seen", true
