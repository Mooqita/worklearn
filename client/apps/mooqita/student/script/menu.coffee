Template.student_menu.onCreated ->
	self = this

	self.autorun ->
		filter =
			owner_id: Meteor.userId()

		Meteor.subscribe "responses", "Messages", filter, "find messages"


Template.student_menu.helpers
	credits: () ->
		profile = get_profile()
		r = profile.requested
		p = profile.provided

		return p-r

	num_new_messages: () ->
		filter =
			owner_id: Meteor.userId()
			seen: false

		return Messages.find(filter).count()

