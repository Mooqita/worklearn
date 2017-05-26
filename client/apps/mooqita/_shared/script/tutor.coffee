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

########################################
Template.tutor_solutions.helpers
	solutions: () ->
		return Tutor_Solutions.find filter


