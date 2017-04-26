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
		self.subscribe "challenges"


########################################
Template.student_find_challenges.helpers
	challenges: () ->
		filter =
			type_identifier: "challenge"

		return Responses.find(filter)


########################################
# Challenge preview
########################################

########################################
Template.student_challenge_preview.onCreated ->
	self = this
	Session.set "selected_challenge", 0

	self.autorun () ->
		self.subscribe "my_solutions_by_challenge_id", self.data._id

########################################
Template.student_challenge_preview.helpers
	has_solution:() ->
		filter =
			owner_id: Meteor.userId()
			type_identifier: "solution"
			challenge_id: this._id

		return Responses.find(filter).count()>0


########################################
Template.student_challenge_preview.events
	"click #student_solution": () ->
		param =
			challenge_id: this._id
			template: "student_solution"
		FlowRouter.setQueryParams param


