Template.learner_menu.onCreated ->
	self = this

	self.autorun ->
		Meteor.subscribe "my_messages"
		Meteor.subscribe "my_feedback"
		Meteor.subscribe "my_reviews"


Template.learner_menu.helpers
	review_time: () ->
		if this.review_time>0
			return how_much_time this.review_time

	feedback_time: () ->
		if this.feedback_time>0
			return how_much_time this.feedback_time

	num_new_messages: () ->
		crs = get_my_documents("messages", {seen:false})
		return crs.count()

