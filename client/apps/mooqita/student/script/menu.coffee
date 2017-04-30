Template.student_menu.onCreated ->
	self = this

	self.autorun ->
		filter =
			type_identifier: "message"
			owner_id: Meteor.userId()

		Meteor.subscribe "responses", filter, "find messages"


Template.student_menu.helpers
	credits: () ->
		profile = get_profile()
		r = profile.requested
		p = profile.provided

		return p-r

	num_new_messages: () ->
		filter =
			type_identifier: "message"
			owner_id: Meteor.userId()

		return Responses.find(filter).count()

