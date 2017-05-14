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
	self = this
	self.autorun () ->
		self.subscribe "my_solutions"


########################################
Template.student_solutions.helpers
	solutions: () ->
		return Solutions.find()


########################################
# student solution preview
########################################

########################################
Template.student_solution_preview.onCreated ->
	self = this

	self.autorun () ->
		id = self.data.challenge_id
		if not id
			return

		self.subscribe "challenge_by_id", id


########################################
Template.student_solution_preview.helpers
	challenge: () ->
		return Challenges.findOne this.challenge_id


########################################
Template.student_solution_preview.events
	"click #student_solution": () ->
		param =
			challenge_id: this.challenge_id
			template: "student_solution"
		FlowRouter.setQueryParams param


########################################
# student solution editor
########################################

########################################
Template.student_solution.onCreated ->
	self = this
	self.autorun () ->
		if not FlowRouter.getQueryParam("challenge_id")
			return
		self.subscribe "challenge_by_id", FlowRouter.getQueryParam("challenge_id")
		self.subscribe "my_solutions_by_challenge_id", FlowRouter.getQueryParam("challenge_id")


########################################
Template.student_solution.helpers
	challenge: () ->
		id = FlowRouter.getQueryParam("challenge_id")
		res = Challenges.findOne id
		return res

	solutions: () ->
		filter =
			challenge_id: FlowRouter.getQueryParam("challenge_id")
			owner_id: Meteor.userId()

		res = Solutions.find filter
		return res

	has_solutions: () ->
		filter =
			challenge_id: FlowRouter.getQueryParam("challenge_id")
			owner_id: Meteor.userId()

		res = Solutions.find filter
		return res.count()>0

########################################
Template.student_solution.events
	"click #take_challenge":()->
		id = FlowRouter.getQueryParam("challenge_id")
		Meteor.call "add_solution", id,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success "Challenge accepted!"


##############################################
# solution reviews
##############################################

##############################################
Template.student_solution_reviews.onCreated ->
	self = this
	self.publishing = new ReactiveVar(false)

	self.autorun () ->
		self.subscribe "reviews_by_solution_id", self.data._id


##############################################
Template.student_solution_reviews.helpers
	missing_reviews: () ->
		challenge = Challenges.findOne this.challenge_id
		reviews_required = challenge.num_reviews
		reviews_provided = this.completed

		res = "" + (reviews_required - reviews_provided)
		return res

	reviews: () ->
		filter =
			solution_id: this._id
		res = Reviews.find filter
		return res

	review_link: () ->
		return "/user?template=student_reviews&challenge_id="+this.challenge_id

	publish_disabled: () ->
		if Template.instance().publishing.get()
			return "disabled"
		if not this.content
			return "disabled"
		return ""


########################################
Template.student_solution_reviews.events
	"click #publish_solution":(event)->
		if event.target.attributes.disabled
			return

		data =
			id: this._id
			publishing: Template.instance().publishing

		Modal.show 'publish_solution', data

	"click #request_review":(event)->
		if event.target.attributes.disabled
			return

		Meteor.call 'request_review', this._id,
			(err, rsp) ->
				if err
					sAlert.error err
				if res
					sAlert.success "Review requested!"


##############################################
# publish modal
##############################################

##############################################
Template.publish_solution.events
	'click #publish': ->
		self = this
		self.publishing.set true

		Meteor.call "finish_solution", self.id,
			(err, res) ->
				self.publishing.set false

				if err
					sAlert.error(err)
				if res
					sAlert.success "Solution published!"

