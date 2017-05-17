##############################################
#
#student_feedback_review
#
##############################################

##############################################
Template.student_feedback_review.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe "feedback_by_review_id", self.data._id


##############################################
Template.student_feedback_review.helpers
	feedback: () ->
		filter =
			parent_id: this._id
		return Feedback.findOne filter


##############################################
#
#student_review_feedback
#
##############################################

########################################
# feedback editor
########################################

########################################
Template.student_feedback_solution.onCreated ->
	self = this

	self.autorun () ->
		self.subscribe "my_feedback_by_review_id", self.data._id


########################################
Template.student_feedback_solution.helpers
	feedback: () ->
		filter =
			parent_id: this._id
		return Feedback.findOne filter

	publishable: () ->
		data = Template.currentData()

		if not data.content
			return false

		if data.rating
			return true

		return false

	public_rating:() ->
		data = Template.currentData()

		if not data.published
			return false

		if not data.rating
			return false

		if data.content
			return true

		return false

	publish_disabled: () ->
		data = Template.currentData()

		field_value = get_field_value data, "content", data._id, "Feedback"
		if not field_value
			return "disabled"

		val = get_field_value data, "rating", data._id, "Feedback"
		if not val
			return "disabled"

		return ""

########################################
Template.student_feedback_solution.events
	"click #publish_feedback":()->
		if event.target.attributes.disabled
			return

		data =
			feedback_id: this._id
		Modal.show 'publish_feedback', data

##############################################
# publish modal
##############################################

##############################################
Template.publish_feedback.events
	'click #publish': ->
		Meteor.call "finish_feedback", this.feedback_id,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success "Feedback published!"

