#######################################################
Template.learner_messages.helpers
	messages: () ->
		mod =
			sort:
				seen: 1
				title: 1

		return get_my_documents "messages", {}, mod


#######################################################
Template.learner_messages.events
	"click #message": ->
		Meteor.call "set_field", "Messages", this._id, "seen", true,
			(err, rsp) ->
				if err
					sAlert.error "Click message error: " + err
