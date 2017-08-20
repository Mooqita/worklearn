Template.student_messages.helpers
	messages: () ->
		filter =
			owner_id: Meteor.userId()

		mod =
			sort:
				seen: 1
				title: 1

		return Messages.find filter, mod

Template.student_messages.events
	"click #message": ->
		Meteor.call "set_field", "Messages", this._id, "seen", true,
			(err, rsp) ->
				if err
					sAlert.error "Click message error: " + err
