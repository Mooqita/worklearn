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
# Challenge preview
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

