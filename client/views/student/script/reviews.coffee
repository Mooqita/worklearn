########################################
#
# student review
#
########################################

########################################
# review list
########################################

########################################
Template.student_reviews.onCreated ->
	this.searching = new ReactiveVar(false)
	Session.set "find_review_error", false

########################################
Template.student_reviews.helpers
	reviewed_challenges: () ->
		filter = {}
		mod =
			fields:
				challenge_id: 1
		res = []
		unique = {}
		reviews = Reviews.find(filter, mod).fetch()
		for rev in reviews
			if rev.challenge_id of unique
				continue

			res.push
				challenge_id: rev.challenge_id
			unique[rev.challenge_id] = rev.challenge_id

		return res

	reviews: (challenge_id) ->
		filter =
			challenge_id: challenge_id
		reviews = Reviews.find(filter).fetch()

		first = true
		for rev in reviews
			rev.first = first
			first = false

		return reviews

	error_message: () ->
		Session.get "find_review_error"

	searching: () ->
		Template.instance().searching.get()

########################################
_handle_error = (err) ->
	if err.error == "no-solution"
		Session.set "find_review_error", true

	sAlert.error err
	console.log err

########################################
Template.student_reviews.events
	"click #find_review": () ->
		inst = Template.instance()
		inst.searching.set true
		Session.set "find_review_error", false

		Meteor.call "assign_review",
			(err, res) ->
				inst.searching.set false
				if err
					_handle_error err
				if res
					sAlert.success "Review received!"


########################################
# review preview
########################################

########################################
Template.student_review_preview.onCreated ->
	self = this
	self.autorun () ->
		id = self.data.challenge_id
		self.subscribe "challenge_by_id", id


########################################
Template.student_review_preview.helpers
	challenge: () ->
		return Challenges.findOne this.challenge_id

	review_url: () ->
		param =
			review_id: this._id
			solution_id: this.solution_id
			challenge_id: this.challenge_id
		return build_url "student_review", param


########################################
# review editor
########################################

########################################
Template.student_review.onCreated ->
	self = this
	self.challenge_expanded = new ReactiveVar(false)

	self.autorun () ->
		if not FlowRouter.getQueryParam("solution_id")
			return

		self.subscribe "solution_by_id", FlowRouter.getQueryParam("solution_id")
		self.subscribe "challenge_by_id", FlowRouter.getQueryParam("challenge_id")

########################################
Template.student_review.helpers
	solution_url: ()->
		param =
			solution_id: FlowRouter.getQueryParam("solution_id")
			challenge_id: FlowRouter.getQueryParam("challenge_id")
		return build_url "student_solution", param

	challenge: () ->
		id = FlowRouter.getQueryParam("challenge_id")
		return Challenges.findOne id

	solution: () ->
		id = FlowRouter.getQueryParam("solution_id")
		return Solutions.findOne id

	review: () ->
		id = FlowRouter.getQueryParam("review_id")
		return Reviews.findOne id

	publish_disabled: () ->
		data = Template.currentData()

		if not data.content
			return "disabled"

		rating = data.rating
		if not rating
			return "disabled"

		return ""


########################################
Template.student_review.events
	"click #publish":(event)->
		if event.target.attributes.disabled
			return

		data =
			response_id: FlowRouter.getQueryParam("review_id")
		Modal.show 'publish_review', data


##############################################
# publish modal
##############################################

##############################################
Template.publish_review.events
	'click #publish': ->
		Meteor.call "finish_review", this.response_id,
			(err, res) ->
				if err
					sAlert.error "Publish review error: " + err
				if res
					sAlert.success "Review published!"


