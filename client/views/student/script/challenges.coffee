########################################
#
# find challenges
#
########################################

########################################
Template.learner_find_challenges.onCreated ->
	self = this
	Session.set "selected_challenge", 0
	
	self.autorun () ->
		#self.subscribe "challenges"


########################################
Template.learner_find_challenges.helpers
	challenges: () ->
		return Challenges.find()


########################################
# Challenge preview
########################################

########################################
Template.learner_challenge_preview.onCreated ->
	self = this
	Session.set "selected_challenge", 0

	self.autorun () ->
		self.subscribe "my_solutions_by_challenge_id", self.data._id

########################################
Template.learner_challenge_preview.helpers
	has_solution:() ->
		solutions_cursor = get_my_documents "solutions", {challenge_id: this._id}
		return solutions_cursor.count() > 0

