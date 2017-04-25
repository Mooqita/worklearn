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
		#data = Template.currentData()

		filter =
			type_identifier: "challenge"
			#text: data.query
		self.subscribe "responses", filter, "student_find_challenges: challenges"

		filter =
			owner_id: Meteor.userId()
			type_identifier: "solution"
		self.subscribe "responses", filter, "student_find_challenges: solutions"


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
Template.student_challenge_preview.helpers
	has_solution:() ->
		filter =
			type_identifier: "solution"
			parent_id: this._id

		return Responses.find(filter).count()>0


########################################
Template.student_challenge_preview.events
	"click #student_solution": () ->
		param =
			item_id: this._id
			template: "student_solution"
		FlowRouter.setQueryParams param


