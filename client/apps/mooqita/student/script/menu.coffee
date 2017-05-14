Template.student_menu.onCreated ->
	self = this

	self.autorun ->
		filter =
			owner_id: Meteor.userId()

		Meteor.subscribe "responses", "Messages", filter, "find messages"
		Meteor.subscribe "credits"


Template.student_menu.helpers
	credits: () ->
		return User_Credits.find()

	review_time: () ->
		if this.review_time>0
			return how_much_time this.review_time

	feedback_time: () ->
		if this.feedback_time>0
			return how_much_time this.feedback_time

	num_new_messages: () ->
		filter =
			owner_id: Meteor.userId()
			seen: false

		return Messages.find(filter).count()

