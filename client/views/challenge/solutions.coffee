########################################
#
# learner solutions
#
########################################

##########################################################
# import
##########################################################

##########################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter

########################################
# functions
########################################

##############################################
_items_missing = (collection, challenge_id) ->
	challenge = Challenges.findOne challenge_id
	items_required = challenge.num_reviews

	filter =
		published: true

	if challenge_id
		filter.challenge_id = challenge_id

	items_provided = get_my_documents(collection, filter).count()
	res = items_required - items_provided
	return res


########################################
# list
########################################

########################################
Template.solutions.onCreated ->

########################################
Template.solutions.helpers


########################################
# learner solution preview
########################################

########################################
Template.solution_preview.onCreated ->
	self = this

	self.autorun () ->
		challenge_id = self.data.challenge_id
		if not challenge_id
			return

		self.subscribe "published_challenge_by_id", challenge_id


########################################
Template.solution_preview.helpers
	is_finished: () ->
		r = _items_missing Reviews, this.challenge_id
		f = _items_missing Feedback, this.challenge_id

		if r<=0 and f<=0
			return true

		return false

	challenge: () ->
		return Challenges.findOne this.challenge_id


########################################
# learner solution editor
########################################

########################################
Template.solution.onCreated ->
	self = this
	self.autorun () ->
		if not FlowRouter.getQueryParam("challenge_id")
			return

		console.log("subscribe")
		challenge_id = FlowRouter.getQueryParam("challenge_id")
		sol_admissions = get_admissions(Meteor.user(), OWNER, Solutions, IGNORE, {challenge_id:challenge_id})
		rev_admissions = get_admissions(Meteor.user(), OWNER, Reviews, IGNORE, {challenge_id:challenge_id})

		self.subscribe "published_challenge_by_id", challenge_id,
		self.subscribe "my_solutions_by_challenge_id", challenge_id, sol_admissions.fetch()
		self.subscribe "reviews_by_challenge_id", challenge_id, rev_admissions.fetch()

########################################
Template.solution.helpers
	nlg_answer: () ->
		no_login = FlowRouter.getQueryParam("nlg")
		if no_login == "answer"
			return true

		return false


	logged_in: () ->
		user = Meteor.user()
		if user
			return true

		AccountsTemplates.setState("signUp")
		return false

	challenge: () ->
		id = FlowRouter.getQueryParam "challenge_id"
		res = Challenges.findOne id
		return res

	solutions: () ->
		filter =
			challenge_id: FlowRouter.getQueryParam "challenge_id"

		crs = get_my_documents "solutions", filter
		return crs

	has_solutions: () ->
		filter =
			challenge_id: FlowRouter.getQueryParam "challenge_id"

		if not Meteor.user()
			return false

		crs = get_my_documents "solutions", filter
		return crs.count() > 0


########################################
Template.solution.events
	"click #send_answer_only_solution": (event, template)->
		id = FlowRouter.getQueryParam "challenge_id"

		mail = template.$("#at-field-email")[0].value
		name = template.$("#at-field-name")[0].value
		solution = template.$("#answer_solution")[0].value

		Meteor.call "add_answer_only_solution", mail, name, solution, id,
			(err, res) ->
				if err
					sAlert.error("There was an error sending your idea please try again later.")
				if res
					sAlert.success("You successfully send your idea.")

	"click #take_challenge":()->
		id = FlowRouter.getQueryParam("challenge_id")
		company_tag = FlowRouter.getQueryParam("company_tag")
		Meteor.call "add_solution", id, company_tag,
			(err, res) ->
				if err
					sAlert.error("Take challenge error: " + err)
				if res
					sAlert.success "Challenge accepted!"


##############################################
# solution reviews
##############################################

##############################################
Template.solution_reviews.onCreated ->
	self = this
	self.publishing = new ReactiveVar false
	self.review_error = new ReactiveVar false
	self.searching = new ReactiveVar false

	self.autorun () ->
		solution_id = self.data._id
		self.subscribe "my_feedback_by_solution_id", solution_id

##############################################
Template.solution_reviews.helpers
	has_filled_profile: () ->
		profile = Profiles.findOne()

		if profile.job_interested
			return true
		return false

	is_finished: () ->
		r = _items_missing Reviews, this.challenge_id
		f = _items_missing Feedback, this.challenge_id

		if r<=0 and f<=0
			return true

		return false

	is_review_missing: () ->
		r = _items_missing Reviews, this.challenge_id
		return r>0

	is_feedback_missing: () ->
		f = _items_missing Feedback, this.challenge_id
		return f>0

	missing_reviews: () ->
		n = _items_missing Reviews, this.challenge_id
		res = "" + n
		return res

	missing_feedback: () ->
		n =_items_missing Feedback, this.challenge_id
		res = "" + n
		return res

	can_start_review: () ->
		filter =
			challenge_id: this.challenge_id

		challenge = Challenges.findOne this.challenge_id
		items_required = challenge.num_reviews
		items_provided = get_my_documents(Reviews, filter).count()

		return items_required > items_provided

	reviews_received: () ->
		filter =
			challenge_id: this.challenge_id
			requester_id: Meteor.userId()
			published: true

		res = Reviews.find filter
		return res

	review_error: () ->
		return Template.instance().review_error.get()

	searching: () ->
		return Template.instance().searching.get()

	solution_ready: () ->
		filter =
			solution_id: this._id
		feedback = Feedback.find filter
		return feedback.count() > 0

	publish_disabled: () ->
		if Template.instance().publishing.get()
			return "disabled"
		if not this.content
			return "disabled"
		return ""


########################################
Template.solution_reviews.events
	"click #find_review": (event)->
		if event.target.attributes.disabled
			return

		event.preventDefault()

		ins = Template.instance()
		ins.review_error.set false
		ins.searching.set true

		challenge_id = this.challenge_id

		Meteor.call 'assign_review_with_challenge', challenge_id,
			(err, rsp) ->
				ins.searching.set false

				if err
					ins.review_error.set true
					sAlert.error "Find solution to review error: " + err
				if rsp
					ins.review_error.set false
					param =
						review_id: rsp.review_id
						solution_id: rsp.solution_id
						challenge_id: rsp.challenge_id
					return FlowRouter.go build_url "review", param

	"click #request_review":(event)->
		if event.target.attributes.disabled
			return

		Meteor.call 'request_review', this._id,
			(err, rsp) ->
				if err
					sAlert.error "Request review error: " + err
				if rsp
					sAlert.success "Review requested!"


	"click #publish_solution":(event)->
		if event.target.attributes.disabled
			return

		data =
			id: this._id
			publishing: Template.instance().publishing

		Modal.show 'publish_solution', data

	"click #republish": () ->
		self = this
		template = Template.instance()
		template.publishing.set true

		Meteor.call "finish_solution", self._id,
			(err, res) ->
				template.publishing.set false

				if err
					sAlert.error "Republish error: " + err
				if res
					sAlert.success "Solution published!"

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
					sAlert.error "Likert item error: " + err
				if res
					sAlert.success "Solution published!"

