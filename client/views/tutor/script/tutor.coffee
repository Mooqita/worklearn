##########################################################
# import
##########################################################

##########################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter


########################################
# tutor
########################################

########################################
Template.tutor.onCreated ->
	this.query = new ReactiveDict()

########################################
Template.tutor.helpers
	page: () ->
		return String(Template.instance().page.get())

	query: () ->
		return Template.instance().query

	challenges: () ->
		return Challenges.find()

	challenge_url: () ->
		queryParams =
			challenge_id: this._id
		url = build_url "tutor_solutions", queryParams
		return url

########################################
Template.tutor.events
	"change #query":(event)->
		event.preventDefault()
		q = event.target.value
		ins = Template.instance()
		ins.query.set "query", q


########################################
# solutions
########################################

########################################
Template.tutor_solutions.onCreated ->
	self = this
	self.parameter = new ReactiveDict()
	self.parameter.set "challenge_id", FlowRouter.getQueryParam "challenge_id"

	self.autorun () ->
		challenge_id = self.parameter.get "challenge_id"
		self.subscribe "published_challenge_by_id", challenge_id

########################################
Template.tutor_solutions.helpers
	parameter: () ->
		return Template.instance().parameter

	challenge: () ->
		challenge_id = FlowRouter.getQueryParam "challenge_id"
		return Challenges.findOne challenge_id

	solutions: () ->
		mod =
			sort:
				under_review_since: 1

		return Solutions.find mod

	solution_url: () ->
		challenge_id = FlowRouter.getQueryParam "challenge_id"
		queryParams =
			solution_id: this.solution_id
			challenge_id: challenge_id
		url = build_url "tutor_solution", queryParams
		return url


########################################
# solution
########################################

########################################
Template.tutor_solution.onCreated ->
	self = this
	self.loading_review = new ReactiveVar false
	self.review_url = new ReactiveVar ""

	self.autorun () ->
		challenge_id = FlowRouter.getQueryParam "challenge_id"
		solution_id = FlowRouter.getQueryParam "solution_id"
		self.subscribe "published_challenge_by_id", challenge_id
		self.subscribe "solution_by_id", solution_id

########################################
Template.tutor_solution.helpers
	loading: () ->
		return Template.instance().loading_review.get()

	review_url: () ->
		return Template.instance().review_url.get()

	challenge: () ->
		challenge_id = FlowRouter.getQueryParam "challenge_id"
		return Challenges.findOne challenge_id

	solution: () ->
		solution_id = FlowRouter.getQueryParam "solution_id"
		return Solutions.findOne solution_id

########################################
Template.tutor_solution.events
	"click #review":()->
		ins = Template.instance()
		ins.loading_review.set true

		solution_id = FlowRouter.getQueryParam "solution_id"
		Meteor.call "add_tutor_review", solution_id,
			(err, res)->
				ins.loading_review.set false
				if err
					sAlert.error "Tutor start review error: " + err
				else
					queryParams =
						review_id: res.review_id
						solution_id: res.solution_id
						challenge_id: res.challenge_id
					url = build_url "review", queryParams
					ins.review_url.set url

