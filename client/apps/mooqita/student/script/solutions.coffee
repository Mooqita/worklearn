########################################
#
# student solutions
#
########################################

########################################
# list
########################################

########################################
Template.student_solutions.onCreated ->
	Session.set "selected_solution", 0

	self = this
	self.autorun () ->
		filter =
			owner_id: Meteor.userId()
			type_identifier: "solution"

		self.subscribe "responses", filter, "student_solutions"



########################################
Template.student_solutions.helpers
	solutions: () ->
		filter =
			type_identifier: "solution"

		return Responses.find(filter)


########################################
# student solution preview
########################################

########################################
Template.student_solution_preview.onCreated ->
	self = this
	self.challenge_expanded = new ReactiveVar(false)

	self.autorun () ->
		filter =
			_id: self.data.parent_id

		self.subscribe "responses", filter, "student_solution_preview: load challenge"


########################################
Template.student_solution_preview.helpers
	challenge: () ->
		return Responses.findOne this.parent_id


########################################
Template.student_solution_preview.events
	"click #student_solution": () ->
		param =
			item_id: this.parent_id
			template: "student_solution"
		FlowRouter.setQueryParams param


########################################
# student solution editor
########################################

########################################
Template.student_solution.onCreated ->
	self = this

	self.challenge_expanded = new ReactiveVar(false)
	self.solution_published = new ReactiveVar(false)
	self.solution_id = new ReactiveVar("")

	self.autorun () ->
		filter =
			_id: FlowRouter.getQueryParam("item_id")
		self.subscribe "responses", filter, "student_solution: challenge"

		filter =
			owner_id: Meteor.userId()
			type_identifier: "solution"
			parent_id: FlowRouter.getQueryParam("item_id")
		self.subscribe "responses", filter, "student_solution: solution"


########################################
Template.student_solution.helpers
	solution: () ->
		filter =
			type_identifier: "solution"
			parent_id: this._id
			owner_id: Meteor.userId()
		res = Responses.findOne filter

		return res

	feedback: () ->
		filter =
			type_identifier: "feedback"
			parent_id: this._id
		res = Responses.findOne filter

		return res

	publish_disabled: () ->
		data = Template.currentData()
		field_value = get_field_value data, "content", data._id, "Responses"
		if not field_value
			return "disabled"
		return ""

	solution_is_public: () ->
		filter =
			type_identifier: "solution"
			parent_id: this._id
		solution = Responses.findOne filter

		if solution.published
			return true

		return Template.instance().solution_published.get()

########################################
Template.student_solution.events
	"click #publish":()->
		data = Template.instance().data
		Modal.show('publish_solution', data)

	"click #take_challenge":()->
		Meteor.call "add_solution", this._id,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success "Challenge accepted!"


##############################################
# publish modal
##############################################

##############################################
Template.publish_solution.events
	'click #publish': ->
		filter =
			type_identifier: "solution"
			parent_id: this._id
		solution = Responses.findOne filter

		Meteor.call "request_review", solution._id,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success "Solution published!"
					self.solution_published.set true


