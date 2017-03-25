#########################################################
Template.work_to_learn.onCreated ->
	self = this

	self.autorun () ->
		on_stop = (err) ->
			if err
				sAlert.error(err)
				console.log(err)

		on_ready = (res) ->
			#sAlert.success("Success!")

		handler =
			onStop: on_stop
			onReady: on_ready

		data = Template.currentData()
		page = if data.page then data.page else 1
		count = if data.num_results then data.num_results else 10
		min = if data.min_price then data.min_price else 100
		max = if data.max_price then data.max_price else 200

		page =  page + ";" + count
		budget = min + "-" + max

		self.subscribe "find_upwork_work",
			data.query, page, budget, handler

#########################################################
Template.work_to_learn.events

#########################################################
Template.work_to_learn.helpers
	upwork_tasks: () ->
		tasks = Tasks.find().fetch()
		return tasks

#########################################################
Template.work_to_learn.events
	"click #add_task":() ->
		this.group_name = "challenge"
		this.template_id = "challenge"

		Meteor.call "add_response_with_data", this


#########################################################
#
# Tasks
#
#########################################################

#########################################################
Template.tasks.onCreated ->
	self = this

	self.autorun () ->
		self.subscribe "responses_with_data", "challenge"

#########################################################
Template.tasks.helpers
	tasks: () ->
		filter =
			group_name: "challenge"
		res = Responses.find filter
		console.log res
		return res
