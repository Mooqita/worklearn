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
	question: () ->
		if this.question
			return this.question

		return "You have not created a question."

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

		question  = get_field_value data, "question", data._id, "Questions"

		if not question
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
	"click #publish": (event)->
		if event.target.attributes.disabled
			return

		Meteor.call "finish_question", this._id,
			(err, res) ->
				if err
					sAlert.error("Finish question error: " + err)
				if res
					sAlert.success "Question published!"
