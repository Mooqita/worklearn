########################################
#
# student solutions
#
########################################

########################################
# functions
########################################

##############################################
_reviews_missing = (challenge_id, solution_id) ->
	challenge = Challenges.findOne challenge_id
	reviews_required = challenge.num_reviews

	filter =
		#solution_id: solution_id
		challenge_id: challenge_id
		review_value:
			$gt: 0

	credits = User_Credits.find filter
	reviews_provided = credits.count()

	res = reviews_required - reviews_provided
	return res

##############################################
_feedback_missing = (challenge_id, solution_id) ->
	challenge = Challenges.findOne challenge_id
	reviews_required = challenge.num_reviews

	filter =
		#solution_id:
		#	$ne:solution_id
		challenge_id: challenge_id
		feedback_value:
			$gt: 0

	credits = User_Credits.find filter
	feedback_provided = credits.count()

	res = reviews_required - feedback_provided
	return res


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
		challenge_id = self.data.challenge_id
		if not challenge_id
			return

		self.subscribe "challenge_by_id", challenge_id


########################################
Template.student_solution_preview.helpers
	is_finished: () ->
		r = _reviews_missing(this.challenge_id, this.solution_id)
		f = _feedback_missing(this.challenge_id, this.solution_id)

		if not r and not f
			return true

		return false

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
	self.publishing = new ReactiveVar false
	self.review_error = new ReactiveVar false
	self.searching = new ReactiveVar false

	self.autorun () ->
		self.subscribe "reviews_by_solution_id", self.data._id


##############################################
Template.student_solution_reviews.helpers
	is_finished: () ->
		r = _reviews_missing this.challenge_id
		f = _feedback_missing this.challenge_id

		if r==0 and f==0
			return true

		return false

	is_review_missing: () ->
		res = _reviews_missing this.challenge_id
		console.log res+" reviews"
		return res

	is_feedback_missing: () ->
		res = _feedback_missing this.challenge_id
		console.log res+" feedback"
		return res

	missing_reviews: () ->
		n = _reviews_missing this.challenge_id
		res = "" + n
		return res

	missing_feedback: () ->
		challenge = Challenges.findOne this.challenge_id
		reviews_required = challenge.num_reviews

		filter =
			challenge_id: this.challenge_id
			feedback_value:
				$gt: 0

		credits = User_Credits.find filter
		feedback_provided = credits.count()

		res = "" + (reviews_required - feedback_provided)
		return res

	reviews: () ->
		filter =
			solution_id: this._id
		res = Reviews.find filter
		return res

	review_error: () ->
		return Template.instance().review_error.get()

	searching: () ->
		return Template.instance().searching.get()

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

	"click #add_review": (event)->
		if event.target.attributes.disabled
			return

		event.preventDefault()

		ins = Template.instance()
		ins.review_error.set false
		ins.searching.set true

		challenge_id = this.challenge_id

		Meteor.call 'add_review_for_challenge', challenge_id,
			(err, rsp) ->
				ins.searching.set false

				if err
					ins.review_error.set true
					sAlert.error err
				if rsp
					ins.review_error.set false
					param =
						review_id: rsp.review_id
						solution_id: rsp.solution_id
						challenge_id: rsp.challenge_id
						template: "student_review"
					FlowRouter.setQueryParams param

	"click #request_review":(event)->
		if event.target.attributes.disabled
			return

		Meteor.call 'request_review', this._id,
			(err, rsp) ->
				if err
					sAlert.error err
				if rsp
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

