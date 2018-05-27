##############################################
#
#feedback_review
#
##############################################

##############################################
Template.feedback_review.onCreated ->
	self  = this
	self.autorun () ->
		self.subscribe "feedback_by_review_id", self.data._id

##############################################
Template.feedback_review.helpers
	feedback: () ->
		filter =
			review_id: this._id
		feedback = Feedback.findOne filter
		if feedback
			if feedback.published
				return feedback

		return null


##############################################
#
# review_feedback
#
##############################################

########################################
# feedback editor
########################################

########################################
Template.feedback_solution.onCreated ->
	this.publishing = new ReactiveVar(false)

########################################
Template.feedback_solution.helpers
	feedback: () ->
		filter =
			review_id: this._id
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

	repair_disabled: () ->
		if Template.instance().publishing.get()
			return "disabled"


	publish_disabled: () ->
		data = Template.currentData()

		if Template.instance().publishing.get()
			return "disabled"

		field_value = get_field_value data, "content", data._id, "Feedback"
		if not field_value
			return "disabled"

		val = get_field_value data, "rating", data._id, "Feedback"
		if not val
			return "disabled"

		return ""

########################################
Template.feedback_solution.events
	"click #publish_feedback":(event)->
		if event.target.attributes.disabled
			return

		data =
			feedback_id: this._id
		Modal.show 'publish_feedback', data

	"click #repair_feedback": () ->
		if event.target.attributes.disabled
			return

		self = this
		template = Template.instance()
		template.publishing.set true

		Meteor.call "repair_feedback", self._id,
			(err, res) ->
				template.publishing.set false

				if err
					sAlert.error "Repair feedback error: " + err
				if res
					sAlert.success "Feedback repaired!"


##############################################
# publish modal
##############################################

##############################################
Template.publish_feedback.events
	'click #publish': ->
		Meteor.call "finish_feedback", this.feedback_id,
			(err, res) ->
				if err
					sAlert.error "Finish feedback error: " + err
				if res
					sAlert.success "Feedback published!"

