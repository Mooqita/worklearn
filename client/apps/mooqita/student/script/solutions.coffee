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
		if not Responses.findOne this.parent_id
			filter =
				_id: self.data.parent_id

			self.subscribe "responses", filter, false, true,
					"student_solution_preview: load challenge"


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
			type_identifier: "solution"
			parent_id: self.data._id
		solution = Responses.findOne filter

		self.solution_id.set solution._id

		filter =
			type_identifier: "feedback"
			solution_id: solution._id
		self.subscribe "responses", filter, false, false, "student_solution: feedback"


########################################
Template.student_solution.helpers
	solution: () ->
		filter =
			type_identifier: "solution"
			parent_id: this._id
		return Responses.findOne filter

	feedback: () ->
		filter =
			type_identifier: "solution"
			parent_id: this._id
		solution = Responses.findOne filter

		filter =
			solution_id: solution._id
			type_identifier: "feedback"
		return Responses.find filter

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

		if solution.visible_to == "anonymous"
			return true

		return Template.instance().solution_published.get()

########################################
Template.student_solution.events
	"click #publish":()->
		data = Template.instance()
		Modal.show('publish_solution', data)

	"click #take_challenge":()->
		filter =
			parent_id: this._id
			type_identifier: "solution"

		index = Responses.find(filter).count()

		param =
			name: "solution: " + index
			index: index
			parent_id: this._id
			template_id: "solution"
			type_identifier: "solution"

		Meteor.call "add_response", param,
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
		self = this
		Meteor.call "set_field", "Responses", self.solution_id.get(), "visible_to", "anonymous",
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success "Solution published!"
					self.solution_published.set true


