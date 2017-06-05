########################################
# list
########################################

########################################
Template.tutor.onCreated ->
	self = this
	self.count = new ReactiveVar 10
	self.page = new ReactiveVar 0
	self.query = new ReactiveVar ""

	self.autorun () ->
		handler =
			onStop: (err) ->
				if err
					sAlert.error(err)
			onReady: (res) ->
				#sAlert.success("Success!")

		page = self.page.get()
		query = self.query.get()
		count = self.count.get()
		count = if count > 10 then 10 else count

		self.subscribe "challenges",
			query, page, count, handler


########################################
Template.tutor.helpers
	page: () ->
		return String(Template.instance().page.get())

	challenges: () ->
		return Challenges.find()

	challenge_url: () ->
		queryParams =
			challenge_id: this._id
			template: "tutor_solutions"
		url = FlowRouter.path "user", null, queryParams
		return url

########################################
Template.tutor.events
	"change #query":(event)->
		event.preventDefault()
		q = event.target.value
		ins = Template.instance()
		ins.query.set q

	"click #next":()->
		ins = Template.instance()
		p = ins.page.get()
		ins.page.set p+1

	"click #prev":()->
		ins = Template.instance()
		p = ins.page.get()
		if p == 0
			return
		ins.page.set p-1


########################################
# solutions
########################################

########################################
Template.tutor_solutions.onCreated ->
	self = this
	self.count = new ReactiveVar 10
	self.page = new ReactiveVar 0

	self.autorun () ->
		handler =
			onStop: (err) ->
				if err
					sAlert.error(err)
			onReady: (res) ->
				sAlert.success("Success!")

		page = self.page.get()
		count = self.count.get()
		count = if count > 10 then 10 else count
		challenge_id = FlowRouter.getQueryParam "challenge_id"

		self.subscribe "solutions_for_tutors",
			challenge_id, page, count, handler

		self.subscribe "challenge_by_id", challenge_id

########################################
Template.tutor_solutions.helpers
	challenge: () ->
		challenge_id = FlowRouter.getQueryParam "challenge_id"
		return Challenges.findOne challenge_id

	solutions: () ->
		mod =
			sort:
				under_review_since: 1

		return TutorSolutions.find {}, mod

	solution_url: () ->
		challenge_id = FlowRouter.getQueryParam "challenge_id"
		queryParams =
			solution_id: this.solution_id
			challenge_id: challenge_id
			template: "tutor_solution"
		url = FlowRouter.path "user", null, queryParams
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
		self.subscribe "challenge_by_id", challenge_id
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
					sAlert.error(err)
				else
					solution_id = FlowRouter.getQueryParam "solution_id"
					challenge_id = FlowRouter.getQueryParam "challenge_id"
					queryParams =
						review_id: res
						solution_id: solution_id
						challenge_id: challenge_id
						template: "student_review"
					url = FlowRouter.path "user", null, queryParams
					ins.review_url.set url

