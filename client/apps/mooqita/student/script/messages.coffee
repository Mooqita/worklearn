Template.student_messages.helpers
	messages: () ->
		filter =
			type_identifier: "message"
			owner_id: Meteor.userId()

		return Responses.find filter
