########################################
# list
########################################

########################################
Template.list_view.onCreated ->
	Session.set "selected_item", 0
	self = this
	self.autorun () ->
		self.subscribe self.data.subscription

########################################
Template.list_view.helpers
	items:() ->
		console.log(this)
		return get_collection(this.collection_name).find()


