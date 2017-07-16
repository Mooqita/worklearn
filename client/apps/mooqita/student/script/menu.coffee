Template.student_menu.onCreated ->
	self = this

	self.autorun ->
		Meteor.subscribe "my_messages"
		Meteor.subscribe "my_feedback"
		Meteor.subscribe "my_reviews"


Template.student_menu.helpers
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

