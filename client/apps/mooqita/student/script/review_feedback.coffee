##############################################
#
#student_review_feedback
#
##############################################

########################################
# feedback editor
########################################

########################################
Template.student_review_feedback.onCreated ->
	self = this

	self.autorun () ->
		filter =
			_id: self.data.parent_id
		self.subscribe "responses", filter, false, false, "student_review_feedback"


########################################
Template.student_review_feedback.helpers
	review: () ->
		return Responses.findOne this.parent_id

	solution: () ->
		return Responses.findOne this.solution_id

	challenge: () ->
		return Responses.findOne this.challenge_id

	public_rating:() ->
		data = Template.currentData()

		val = get_field_value data, "visible_to", data._id, "Responses"
		if val != "anonymous"
			return false

		val = get_field_value data, "rating", data._id, "Responses"
		if val
			return true

		return false

	publish_disabled: () ->
		data = Template.currentData()

		field_value = get_field_value data, "content", data._id, "Responses"
		if not field_value
			return "disabled"

		val = get_field_value data, "rating", data._id, "Responses"
		if not val
			return "disabled"

		return ""

