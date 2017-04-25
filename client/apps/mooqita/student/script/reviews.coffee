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

	self = this
	self.autorun () ->
		filter =
			owner_id: Meteor.userId()
			type_identifier: "review"

		self.subscribe "responses", filter, "student_reviews"

########################################
Template.student_reviews.helpers
	reviews: () ->
		filter =
			type_identifier: "review"

		return Responses.find(filter)

	searching: () ->
		Template.instance().searching.get()

########################################
Template.student_reviews.events
	"click #find_review": () ->
		inst = Template.instance()
		inst.searching.set true

		Meteor.call "find_review", this._id,
			(err, res) ->
				inst.searching.set false
				if err
					sAlert.error err
				if res
					sAlert.success "Review received!"


########################################
# review preview
########################################

########################################
Template.student_review_preview.onCreated ->
	self = this
	self.autorun () ->
		filter =
			_id: self.data.challenge_id
		self.subscribe "responses", filter, "student_review_preview: challenge"


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
		filter =
			owner_id: Meteor.userId()
			_id: FlowRouter.getQueryParam("review_id")
		self.subscribe "responses", filter, "student_solution: review"

		filter = FlowRouter.getQueryParam("solution_id")
		self.subscribe "solutions", filter, "student_solution: solution"

		filter =
			_id: FlowRouter.getQueryParam("challenge_id")
		self.subscribe "responses", filter, "student_solution: challenge"


########################################
Template.student_review.helpers
	challenge: () ->
		return Responses.findOne FlowRouter.getQueryParam("challenge_id")

	solution: () ->
		id = FlowRouter.getQueryParam("solution_id")
		return Responses.findOne id

	review: () ->
		id = FlowRouter.getQueryParam("review_id")
		return Responses.findOne id

	rating: () ->
		id = FlowRouter.getQueryParam("review_id")
		rating = get_field_value null, "rating", id, "Responses"
		return rating

	publish_disabled: () ->
		id = FlowRouter.getQueryParam("review_id")
		content = get_field_value null, "content", id, "Responses"
		if not content
			return "disabled"

		rating = get_field_value null, "rating", id, "Responses"
		if not rating
			return "disabled"

		return ""


########################################
Template.student_review.events
	"click #publish":()->
		data =
			response_id: FlowRouter.getQueryParam("review_id")
		Modal.show 'publish_review', data

	"click #challenge_expand": (event) ->
		ins = Template.instance()
		s = not ins.challenge_expanded.get()
		ins.challenge_expanded.set s


##############################################
# publish modal
##############################################

##############################################
Template.publish_review.events
	'click #publish': ->
		console.log this
		Meteor.call "finish_review", this.response_id,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success "Review published!"


