########################################
#
# student review
#
########################################

########################################
# review list
########################################

########################################
Template.student_reviews.onCreated ->
	this.searching = new ReactiveVar(false)
	Session.set "find_review_error", false

	self = this
	self.autorun () ->
		self.subscribe "my_reviews"

########################################
Template.student_reviews.helpers
	reviews: () ->
		filter =
			type_identifier: "review"

		return Responses.find(filter)

	error_message: () ->
		Session.get "find_review_error"

	searching: () ->
		Template.instance().searching.get()

########################################
_handle_error = (err) ->
	if err.error == "no-solution"
		Session.set "find_review_error", true

	sAlert.error err
	console.log err

########################################
Template.student_reviews.events
	"click #find_review": () ->
		inst = Template.instance()
		inst.searching.set true
		Session.set "find_review_error", false

		Meteor.call "provide_review",
			(err, res) ->
				inst.searching.set false
				if err
					_handle_error err
				if res
					sAlert.success "Review received!"


########################################
# review preview
########################################

########################################
Template.student_review_preview.onCreated ->
	self = this
	self.autorun () ->
		id = self.data.challenge_id
		self.subscribe "challenge_by_id", id


########################################
Template.student_review_preview.helpers
	challenge: () ->
		return Responses.findOne this.challenge_id


########################################
Template.student_review_preview.events
	"click #student_review": () ->
		param =
			review_id: this._id
			solution_id: this.solution_id
			challenge_id: this.challenge_id
			template: "student_review"
		FlowRouter.setQueryParams param


########################################
# review editor
########################################

########################################
Template.student_review.onCreated ->
	self = this
	self.challenge_expanded = new ReactiveVar(false)

	self.autorun () ->
		if not FlowRouter.getQueryParam("solution_id")
			return

		self.subscribe "solution_by_id", FlowRouter.getQueryParam("solution_id")
		self.subscribe "my_review_by_id", FlowRouter.getQueryParam("review_id")
		self.subscribe "challenge_by_id", FlowRouter.getQueryParam("challenge_id")

########################################
Template.student_review.helpers
	challenge: () ->
		id = FlowRouter.getQueryParam("challenge_id")
		return Responses.findOne id

	solution: () ->
		id = FlowRouter.getQueryParam("solution_id")
		return Responses.findOne id

	review: () ->
		id = FlowRouter.getQueryParam("review_id")
		return Responses.findOne id

	publish_disabled: () ->
		data = Template.currentData()

		if not data.content
			return "disabled"

		rating = data.rating
		if not rating
			return "disabled"

		return ""


########################################
Template.student_review.events
	"click #publish":()->
		if event.target.attributes.disabled
			return

		data =
			response_id: FlowRouter.getQueryParam("review_id")
		Modal.show 'publish_review', data


##############################################
# publish modal
##############################################

##############################################
Template.publish_review.events
	'click #publish': ->
		Meteor.call "finish_review", this.response_id,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success "Review published!"


