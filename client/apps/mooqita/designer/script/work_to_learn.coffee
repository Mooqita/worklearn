#########################################################
Template.work_to_learn.onCreated ->
	self = this

	self.autorun () ->
		handler =
			onStop: (err) ->
				if err
					sAlert.error(err)
			onReady: (res) ->
				#sAlert.success("Success!")

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
		tasks = UpworkTasks.find().fetch()
		return tasks

#########################################################
Template.work_to_learn.events
	"click #add_task":() ->
		this.type_identifier = "challenge"
		this.template_id = "challenge"
		this.content = this.snippet
		this.parent_id = Template.instance().data._id
		this.name = "upwork challenge: " + this.title

		Meteor.call "add_upwork_challenge", this

