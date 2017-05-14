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
			sec = 1000
			min = sec*60
			hrs = min*60
			this.review_time / hrs

	feedback_time: () ->
		if this.feedback_time>0
			sec = 1000
			min = sec*60
			hrs = min*60
			this.feedback_time / hrs

	num_new_messages: () ->
		filter =
			owner_id: Meteor.userId()
			seen: false

		return Messages.find(filter).count()

