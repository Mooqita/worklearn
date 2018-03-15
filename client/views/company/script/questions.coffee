########################################
#
# organization questions view
#
########################################


##########################################################
# import
##########################################################

##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


########################################
# organization questions
########################################

########################################
Template.organization_questions.onCreated ->
	this.parameter = new ReactiveDict()
	Session.set "selected_question", 0

########################################
Template.organization_questions.helpers
	parameter: () ->
		return Template.instance().parameter

	questions: () ->
		filter =
			owner_id: Meteor.userId()

		return Questions.find(filter)

########################################
Template.organization_questions.events
	"change #query":(event)->
		event.preventDefault()
		q = event.target.value
		ins = Template.instance()
		ins.parameter.set "query", q

	"click #add_question": () ->
		Meteor.call "add_question",
			(err, res) ->
				if err
					sAlert.error("Add question error: " + err)


########################################
#
# question_preview
#
#########################################

########################################
Template.question_preview.helpers
	title: () ->
		if this.title
			return this.title

		return "This question does not yet have a title."

	content: () ->
		if this.content
			return this.content

		return "No description available, yet."

	question_link: () ->
		return build_url "organization_question", {question_id: this._id}

	course: () ->
		if this.course
			return this.course

		return "This question does not yet have a subject"



########################################
#
# question
#
########################################

########################################
Template.organization_question.onCreated ->
	self = this
	self.send_disabled = new ReactiveVar(false)

	self.autorun ->
		id = FlowRouter.getQueryParam("question_id")
		if not id
			return
		self.subscribe "my_question_by_id", id


########################################
Template.organization_question.helpers
	question: () ->
		id = FlowRouter.getQueryParam("question_id")
		return Questions.findOne id

	send_disabled: () ->
		if Template.instance().send_disabled.get()
			return "disabled"
		return ""

	publish_disabled: () ->
		data = Template.currentData()

		content = get_field_value data, "content", data._id, "Questions"
		if not content
			return "disabled"

		title = get_field_value data, "title", data._id, "Questions"
		if not title
			return "disabled"

		published = get_field_value data, "published", data._id, "Questions"
		if published
			return "disabled"

		return ""

	share_url: ->
		param =
			question_id: this._id
		url = build_url "learner_solution", param, true
		return url

	course_options:() ->
		return [{value:"", label:"No subject"}
			{value:"comp_thinking", label:"Comp Thinking"}
			{value:"cobol", label:"COBOL"}
			{value:"py", label:"Python"}]

########################################
Template.organization_question.events
	"click #icon_download": (e, n)->
		if document.selection
			range = document.body.createTextRange()
			range.moveToElementText(document.getElementById("question_url"))
			range.select()

		else if window.getSelection
			range = document.createRange()
			range.selectNodeContents(document.getElementById("question_url"))
			selection = window.getSelection()
			selection.removeAllRanges()
			selection.addRange(range)

		return true

	"click #publish": (event)->
		if event.target.attributes.disabled
			return

		Meteor.call "finish_question", this._id,
			(err, res) ->
				if err
					sAlert.error("Finish question error: " + err)
				if res
					sAlert.success "Question published!"


	"click #send": (event, template)->
		if event.target.attributes.disabled
			return

		inst = Template.instance()
		inst.send_disabled.set(true)

		message = template.find("#message").value
		subject = template.find("#subject").value

		Meteor.call "send_message_to_question_learners", this._id, subject, message,
			(err, res) ->
				inst.send_disabled.set(false)
				if err
					sAlert.error "Send message error: " + err
				if res
					sAlert.success "Message send."


########################################
#
# question solutions
#
########################################

########################################
Template.question_solutions.onCreated ->
	this.parameter = new ReactiveDict()
	this.parameter.set "question_id", FlowRouter.getQueryParam("question_id")

########################################
Template.question_solutions.helpers
	parameter: () ->
		return Template.instance().parameter

	question_solutions: () ->
		filter =
			question_id: FlowRouter.getQueryParam("question_id")

		return Solutions.find filter

########################################
Template.question_solutions.events
	"change #public_only": () ->
		event.preventDefault()
		q = event.target.checked
		ins = Template.instance()
		ins.parameter.set "published", q

	"change #query": (event) ->
		event.preventDefault()
		q = event.target.value
		ins = Template.instance()
		ins.parameter.set "query", q

########################################
#
# question solutions
#
########################################

########################################
Template.question_solution.onCreated ->
	self = this
	self.adding_recommendation = new ReactiveVar(false)
	self.reviews_visible = new ReactiveVar(false)

	self.autorun ->
		self.subscribe "user_summary",
			self.data.owner_id,
			self.data.question_id

		self.subscribe "my_recommendation_by_recipient_id",
			self.data.owner_id

########################################
Template.question_solution.helpers
	recommendation: () ->
		filter =
			recipient_id: this.owner_id

		list = Recommendations.find filter

		if list.count() == 0
			return false

		return list

	is_adding: () ->
		val = Template.instance().adding_recommendation.get()
		return val

	resume_url: (author_id) ->
		return author_id

	average_rating: () ->
		filter =
			solution_id: this._id
		mod =
			fields:
				rating: 1
		rev = Reviews.find filter, mod
		r = 0.0
		c = 0.0
		rev.forEach (entry) ->
			if entry.rating
				c += 1
				r += parseInt(entry.rating)

		if c == 0
			return "No reviews yet"

		return "Average rating <em>" + (r/c).toFixed(1) + "</em> out of <em>5</em>"

	reviews: () ->
		filter =
			solution_id: this._id

		crs = Reviews.find filter
		if crs.count()
			return crs

		return false

	feedback: (review_id) ->
		filter =
			review_id: review_id
		return Feedback.find filter

	reviews_visible: ->
		return Template.instance().reviews_visible.get()


########################################
Template.question_solution.events
	"click #show_reviews": ->
		f = Template.instance().reviews_visible.get()
		Template.instance().reviews_visible.set !f

	"click #reopen": ()->
		data =
			id: this._id

		Modal.show 'reopen_solution_question', data

	"click #user_info": () ->
		data = UserSummaries.findOne(this.owner_id)
		data["user_id"] = this.owner_id
		Modal.show 'show_learner_summary_question', data

	"click #edit_recommendation": () ->
		filter =
			recipient_id: this.owner_id

		recommendation = Recommendations.findOne filter

		Modal.show 'recommendation', {recommendation: recommendation}

	"click #add_recommendation": () ->
		Template.instance().adding_recommendation.set true
		Meteor.call "add_recommendation", this.question_id, this.owner_id


##############################################
# publish modal
##############################################

##############################################
Template.reopen_solution_question.events
	'click #reopen': ->
		self = this

		Meteor.call "reopen_solution_question", self.id,
			(err, res) ->
				if err
					sAlert.error "Reopen solution error: " + err
				if res
					sAlert.success "Solution reopened!"
