########################################
Template.paging.onCreated ->
	self = this
	page = self.data.page || 0
	count = self.data.count || 10
	parameter = self.data.parameter || new ReactiveDict()

	if not parameter instanceof ReactiveDict
		throw new Meteor.Error "Parameter needs to be a ReactiveDict."

	self.page = new ReactiveVar page
	self.count = new ReactiveVar count
	self.parameter = parameter

	self.autorun () ->
		handler =
			onStop: (err) ->
				if err
					sAlert.error(err)
			onReady: (res) ->
				sAlert.success("Success!")

		page = self.page.get()
		count = self.count.get()
		subscription = self.data.subscription
		parameter = self.parameter.all()
		count = if count > 100 then 100 else count

		self.subscribe subscription,
			parameter, page, count, handler


########################################
Template.paging.helpers
	page: () ->
		return String(Template.instance().page.get())

	count: () ->
		return String(Template.instance().count.get())


########################################
Template.paging.events
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