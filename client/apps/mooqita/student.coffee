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

		param =
			index: index
			type: "solution"
			name: "user generated challenge: " + index
			template_id: "solution"
			parent_id: this._id

		Meteor.call "add_response", param,
			(err, res) ->
				if err
					sAlert.error(err)

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

		param =
			index: index
			type: "review"
			name: "review: " + index
			template_id: "review"
			parent_id: this._id

		Meteor.call "add_response", param,
			(err, res) ->
				if err
					sAlert.error(err)


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
		data = Template.currentData()

		filter =
			type_identifier: "challenge"
			text: data.query
			
		self.subscribe "responses", filter, false, true, "student_find_challenges"


########################################
Template.student_find_challenges.helpers
	challenges: () ->
		filter =
			type_identifier: "challenge"

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
		filter =
			parent_id: self.data._id

		self.subscribe "responses", filter, true, true, "student_challenge_preview"


########################################
Template.student_challenge_preview.helpers
	has_solution:() ->
		filter =
			parent_id: this._id

		return Responses.find(filter).count()>0


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
# list
########################################

########################################
Template.student_solutions.onCreated ->
	self = this
	self.autorun () ->
		filter =
			type_identifier: "solution"

		self.subscribe "responses", filter, true, true, "student_solutions"


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
		filter =
			_id: self.data.parent_id

		self.subscribe "responses", filter, false, true, "student_solution_preview"


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
		filter =
			_id: self.data._id
		self.subscribe "responses", filter, true, false, "student_solution"

		filter =
			parent_id: self.data._id
		self.subscribe "responses", filter, true, false, "student_solution"


########################################
Template.student_solution.helpers
	challenge: () ->
		return Responses.findOne this._id

	solution: () ->
		filter =
			parent_id: this._id
		return Responses.findOne filter


########################################
Template.student_solution.events
	"click #take_challenge":()->
		filter =
			type_identifier: "solution"

		index = Responses.find(filter).count()

		param =
			index: index
			type: "solution"
			name: "solution: " + index
			template_id: "solution"
			type_identifier: "solution"
			parent_id: this._id

		Meteor.call "add_response", "solution", param,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success "Challenge accepted!"


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
	self = this
	self.searching = new ReactiveVar(false)

	self.autorun () ->
		filter =
			type_identifier: "review"

		self.subscribe "responses", filter, true, true, "student_reviews"


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
			_id: self.data._id
		self.subscribe "responses", filter, false, false, "student_review_preview"

		filter =
			parent_id: self.data._id
		self.subscribe "responses", filter, false, false, "student_review_preview"


########################################
Template.student_review_preview.helpers
	challenge: () ->
		return Responses.findOne this.parent_id


