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
	self.autorun () ->
		if not Responses.findOne this.parent_id
			filter =
				_id: self.data.parent_id

			self.subscribe "responses", filter, false, true, "student_solution_preview: load challenge"


########################################
Template.student_solution_preview.helpers
	challenge: () ->
		return Responses.findOne this.parent_id

	has_more: () ->
		return this.content.length>250

	selected: ->
		return this._id==Session.get "selected_challenge"

	content: () ->
		if this._id==Session.get "selected_challenge"
			return this.content

		return this.content.substring(0, 250)


########################################
Template.student_solution_preview.events
	"click #select": ->
		f = Session.get "selected_solution"
		m = this._id

		if f==m
			Session.set "selected_solution", 0
		else
			Session.set "selected_solution", this._id


	"click #student_solution": () ->
		Session.set "current_data", this
		Session.set "student_template", "student_solution"


########################################
# student solution editor
########################################

########################################
Template.student_solution.onCreated ->
	self = this

	self.autorun () ->
		filter =
			_id: self.data.parent_id
		self.subscribe "responses", filter, false, false, "student_solution: challenge"

		filter =
			type_identifier: "review"
			solution_id: self.data._id
		self.subscribe "responses", filter, false, false, "student_solution: review"


########################################
Template.student_solution.helpers
	challenge: () ->
		return Responses.findOne this.parent_id

	solution: () ->
		return Responses.findOne this._id

	feedback: () ->
		filter =
			solution_id: this._id
			type_identifier: "feedback"
		return Responses.find filter

	publish_disabled: () ->
		data = Template.currentData()
		field_value = get_field_value data, "content", data._id, "Responses"
		if not field_value
			return "disabled"
		return ""

########################################
Template.student_solution.events
	"click #publish":()->
		Modal.show('publish_solution', this)

	"click #take_challenge":()->
		filter =
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
		Meteor.call "set_field", "Responses", this._id, "visible_to", "anonymous",
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success "Solution published!"


