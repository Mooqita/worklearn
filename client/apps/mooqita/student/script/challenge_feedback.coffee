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
Template.student_profile.onCreated ->
	user_id = Meteor.userId()
	self = this

	self.autorun () ->
		filter =
			type_identifier: "profile"
			owner_id: user_id

		self.subscribe "responses", filter, true, false, "student_profile",

########################################
Template.student_profile.helpers
	profile: () ->
		filter =
			type_identifier: "profile"

		res = Responses.findOne filter
		return res

########################################
Template.student_profile.events

########################################
#
# find challenges
#
########################################

########################################
Template.student_find_challenges.onCreated ->
	self = this
	Session.set "selected_challenge", 0
	
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


########################################
Template.student_find_challenges.events


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
			owner_id: Meteor.userId()

		self.subscribe "responses", filter, true, true, "student_challenge_preview: my solutions"


########################################
Template.student_challenge_preview.helpers
	has_solution:() ->
		filter =
			type_identifier: "solution"
			parent_id: this._id

		return Responses.find(filter).count()>0

	has_more: () ->
		return this.content.length>250

	selected: ->
		return this._id==Session.get "selected_challenge"

	content: () ->
		if this._id==Session.get "selected_challenge"
			return this.content

		return this.content.substring(0, 250)


########################################
Template.student_challenge_preview.events
	"click #select": ->
		f = Session.get "selected_challenge"
		m = this._id

		if f==m
			Session.set "selected_challenge", 0
		else
			Session.set "selected_challenge", this._id

	"click #student_solution": () ->
		filter =
			type_identifier: "solution"
			parent_id: this._id
		Session.set "current_data", Responses.findOne filter
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
	Session.set "selected_solution", 0

	self.autorun () ->
		filter =
			type_identifier: "solution"
			owner_id: Meteor.userId()

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
		if Responses.findOne self.data.parent_id
			return

		filter =
			_id: self.data.parent_id

		self.subscribe "responses", filter, false, true, "student_solution_preview: challenge"


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
			_id: self.data._id
		self.subscribe "responses", filter, true, false, "student_solution: solution data"

		filter =
			_id: self.data.parent_id
		self.subscribe "responses", filter, false, false, "student_solution: challenge"

		filter =
			type_identifier: "review"
			solution_id: self.data._id
		self.subscribe "responses", filter, false, false, "student_solution: review"

		filter =
			type_identifier: "feedback"
			solution_id: self.data._id
		self.subscribe "responses", filter, true, false, "student_solution: feedback"


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
Template.publish_solution.events
	'click #publish': ->
		Meteor.call "set_field", "Responses", this._id, "visible_to", "anonymous",
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success "Solution published!"


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

		self.subscribe "responses", filter, true, false, "student_reviews"


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

		console.log self.data
		self.subscribe "responses", filter, false, true, "student_review_preview"


########################################
Template.student_review_preview.helpers
	challenge: () ->
		return Responses.findOne this.challenge_id


########################################
Template.student_review_preview.events
	"click #student_review": () ->
		Session.set "current_data", Responses.findOne this._id
		Session.set "student_template", "student_review"


########################################
# review editor
########################################

########################################
Template.student_review.onCreated ->
	self = this

	self.autorun () ->
		filter =
			_id: self.data._id
		self.subscribe "responses", filter, true, false, "student_solution"

		filter =
			_id: self.data.parent_id
		self.subscribe "responses", filter, true, false, "student_solution"

		filter =
			_id: self.data.challenge_id
		self.subscribe "responses", filter, true, false, "student_solution"


########################################
Template.student_review.helpers
	challenge: () ->
		return Responses.findOne this.challenge_id

	solution: () ->
		filter =
			_id: this.parent_id
		return Responses.findOne filter

	rating: () ->
		data = Template.currentData()
		rating = get_field_value data, "rating", data._id, "Responses"
		return rating

	publish_disabled: () ->
		data = Template.currentData()

		content = get_field_value data, "content", data._id, "Responses"
		if not content
			return "disabled"

		rating = get_field_value data, "rating", data._id, "Responses"
		if not rating
			return "disabled"

		return ""


########################################
Template.student_review.events
	"click #publish":()->
		Modal.show('publish_review', this)

##############################################
# publish modal
##############################################
Template.publish_review.events
	'click #publish': ->
		Meteor.call "set_field", "Responses", this._id, "visible_to", "anonymous",
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success "Review published!"


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
			_id: self.data._id
		self.subscribe "responses", filter, true, false, "student_review_feedback"

		filter =
			_id: self.data.parent_id
		self.subscribe "responses", filter, true, false, "student_review_feedback"

		filter =
			_id: self.data.challenge_id
		self.subscribe "responses", filter, true, false, "student_review_feedback"


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

##############################################
#
# Resume view of solution
# Created by Markus on 15/11/2015.
#
##############################################

##############################################
Template.student_credentials.onCreated () ->
	self = this

	self.autorun () ->
		s_id = FlowRouter.getParam('user_id')
		if !s_id
			s_id = Meteor.userId()
		self.subscribe 'resume_by_user', s_id

##############################################
# helpers
##############################################

##############################################
Template.student_credentials.helpers
	current_resume: ()->
		return Resumes.findOne()

##############################################
Template.resume_solution.helpers
	current_resume: () ->
		return Resumes.findOne()

##############################################
Template.resume_review.helpers
	resume_url: () ->
		return resume_url(this.owner_id)


