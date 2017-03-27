########################################
#
# student view
#
########################################

########################################
Template.student_view.onCreated ->
	Session.set "current_data", null
	Session.set "student_template", "student_profile"

########################################
Template.student_view.helpers
	data: () ->
		data = 	Session.get "current_data"
		return if data then data else this

	selected_view: () ->
		return Session.get "student_template"

########################################
Template.student_menu.events
	"click .student_navigate": (event)->
		lnk = event.target.id
		if lnk
			Session.set "student_template", lnk

########################################
#
# student summary
#
########################################

########################################
Template.student_profile.helpers
	solutions: () ->
		filter =
			template_id: "solution"

		return Responses.find(filter)

	reviews: () ->
		filter =
			template_id: "review"

		return Responses.find(filter)

########################################
Template.student_profile.events
	"click #add_solution": () ->
		filter =
			parent_id: this._id
			template_id: "solution"

		index = Responses.find(filter).count()
		Meteor.call "add_response", "solution", index, this._id

	"click #connect": () ->
		Meteor.call "add_connection", this._id, "blub",
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success("Connection updated: " + field)


	"click #add_review": () ->
		filter =
			parent_id: this._id
			template_id: "review"

		index = Responses.find(filter).count()
		Meteor.call "add_response", "review", index, this._id,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success("Connection updated: " + field)


########################################
#
# find challenges
#
########################################

########################################
Template.student_find_challenges.onCreated ->
	self = this
	self.challenge_id = new ReactiveVar("")
	self.autorun () ->
		self.subscribe "responses_by_group", "challenge"


########################################
Template.student_find_challenges.helpers
	challenges: () ->
		filter =
			group_name: "challenge"

		return Responses.find(filter)

	loaded: () ->
		cur = this._id == Template.instance().challenge_id.get()
		return cur


########################################
Template.student_find_challenges.events
	"click .load-challenge": () ->
		Template.instance().challenge_id.set this._id


########################################
#
# Challenge preview
#
########################################

########################################
Template.student_challenge_preview.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe "response_by_id", self.data._id, false


########################################
Template.student_challenge_preview.events
	"click #student_solution": () ->
		Session.set "current_data", this
		Session.set "student_template", "student_solution"


########################################
#
# student solutions
#
########################################

########################################
Template.student_solutions.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe "responses_by_group", "solution"


########################################
Template.student_solutions.helpers
	solutions: () ->
		filter =
			template_id: "solution"

		return Responses.find(filter)


########################################
Template.student_solutions.events
	"click #take_challenge":()->
		Meteor.call "add_response", "solution", 1, this._id, "solution", true,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success("Challenge accepted!")


########################################
# student solution preview
########################################

########################################
Template.student_solution_preview.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe "response_by_id", self.data._id, false
		self.subscribe "response_by_id", self.data.parent_id, false


########################################
Template.student_solution_preview.helpers
	challenge: () ->
		return Responses.findOne this.parent_id


########################################
Template.student_solution_preview.events
	"click #student_solution": () ->
		Session.set "current_data", Responses.findOne this.parent_id
		Session.set "student_template", "student_solution"


########################################
# student solution editor
########################################

########################################
Template.student_solution.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe "response_by_id", self.data._id, false
		self.subscribe "responses_by_parent", self.data._id, false


########################################
Template.student_solution.helpers
	challenge: () ->
		return Responses.findOne this._id

	solution: () ->
		filter =
			parent_id: this._id
		return Responses.findOne filter


########################################
#
# student reviews
#
########################################

########################################
Template.student_reviews.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe "responses_by_group", "review"


########################################
Template.student_reviews.helpers
	reviews: () ->
		filter =
			template_id: "review"

		return Responses.find(filter)

