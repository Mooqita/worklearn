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
		return Challenges.find()


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
			challenge_id: this._id

		return Solutions.find(filter).count()>0

