########################################
Template.paging.onCreated ->
	self = this
	page = self.data.page || 0
	size = self.data.count || 10
	parameter = self.data.parameter || new ReactiveDict()

	if not parameter instanceof ReactiveDict
		throw new Meteor.Error "Parameter needs to be a ReactiveDict."

	self.page = new ReactiveVar page
	self.size = new ReactiveVar size
	self.parameter = parameter

	self.autorun () ->
		handler =
			onStop: (err) ->
				if err
					sAlert.error(err)
			onReady: (res) ->
				sAlert.success("Success!")

		subscription = self.data.subscription
		parameter = self.parameter.all()
		parameter.page = self.page.get()
		parameter.size = self.size.get()
		count = if count > 100 then 100 else count

		self.subscribe subscription,
			parameter, page, count, handler


########################################
Template.paging.helpers
	page: () ->
		return String(Template.instance().page.get())

	size: () ->
		return String(Template.instance().size.get())


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
