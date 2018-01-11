########################################
Template.paging.onCreated ->
	self = this
	parameter = self.data.parameter || new ReactiveDict()

	if not (parameter instanceof ReactiveDict)
		throw new Meteor.Error "Parameter needs to be a ReactiveDict."

	page = self.data.page || 0
	size = self.data.count || 10
	size = if size > 100 then 100 else size

	self.page = new ReactiveVar page
	self.size = new ReactiveVar size
	self.query = new ReactiveVar parameter.query || ""
	self.parameter = parameter

	self.autorun () ->
		subscription = self.data.subscription
		parameter = self.parameter.all()
		parameter.page = self.page.get()
		parameter.size = self.size.get()
		parameter.query = self.query.get()

		handler =
			onStop: (err) ->
				if err
					sAlert.error("Paging subscript error: " + err)
			onReady: (res) ->
				console.log "Subscription " + subscription + " ready."

		self.subscribe subscription, parameter, handler


########################################
Template.paging.helpers
	page: () ->
		return String(Template.instance().page.get())

	size: () ->
		return String(Template.instance().size.get())

	items: () ->
		data = Template.instance().data
		filter = data.filter || {}
		collection_name = data.collection_name
		if not collection_name
			return []

		collection = get_collection collection_name
		return collection.find filter


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

	"change #query":(event)->
		event.preventDefault()
		q = event.target.value
		ins = Template.instance()
		ins.query.set q

