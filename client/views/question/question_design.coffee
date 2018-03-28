########################################
# organization questions view
########################################

import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

########################################
# Organization Questions
########################################
Template.designed_questions.onCreated ->
	this.parameter = new ReactiveDict()
	Session.set "selected_question", 0

Template.designed_questions.helpers
	parameter: () ->
		return Template.instance().parameter

	questions: () ->
		return get_my_documents Questions

Template.designed_questions.events
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
				if res
					query =
						question_id: res
					url = build_url "question_design", query
					FlowRouter.go url

	"click #template_question": () ->
		url = build_url "question_pool"
		FlowRouter.go url

########################################
#
# question_preview
#
#########################################
Template.question_preview.helpers
	title: () ->
		if this.title
			return this.title

		return "This question does not yet have a title."

	content: () ->
		if this.content
			return this.content

		return "No description available, yet."


########################################
# Question
########################################
Template.question_design.onCreated ->
	self = this
	self.send_disabled = new ReactiveVar(false)

	self.autorun () ->
		id = FlowRouter.getQueryParam("question_id")
		Meteor.subscribe("question_by_id", id)

Template.question_design.helpers
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

Template.question_design.events
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

	"click #publish": (event) ->
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
