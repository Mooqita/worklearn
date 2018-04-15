########################################
#
# learner solutions
#
########################################

##########################################################
# import
##########################################################

##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

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

		self.subscribe "challenge_by_id", challenge_id


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

		challenge_id = FlowRouter.getQueryParam("challenge_id")

		self.subscribe "challenge_by_id", challenge_id
		self.subscribe "my_solutions_by_challenge_id", challenge_id
		self.subscribe "reviews_by_challenge_id", challenge_id


########################################
Template.solution.helpers
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

		crs = get_my_documents "solutions", filter
		return crs.count() > 0


########################################
Template.solution.events
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

	num_reviews: () ->
		filter =
			challenge_id: this.challenge_id

		res = Reviews.find filter
		return res.count()

	can_start_review: () ->
		challenge = Challenges.findOne this.challenge_id
		items_required = challenge.num_reviews
		filter =
			requester_id: Meteor.userId()
			challenge_id: this.challenge_id
		res = Reviews.find filter
		return items_required > res.count()

	reviews: () ->
		filter =
			solution_id: this._id
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

