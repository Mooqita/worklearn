#########################################################
# Files
#########################################################

#########################################################
Template.file_download.onCreated ->
	self = this

	field = FlowRouter.getParam("field")
	item_id = FlowRouter.getParam("item_id")
	collection = FlowRouter.getParam("collection")

	self.autorun () ->
		self.subscribe 'files', collection, item_id, field

#########################################################
Template.file_download.helpers
	file_data: () ->
		file = Files.findOne()
		if file
			return file.data

		return undefined

	file_name: () ->
		return FlowRouter.getParam("file_name")

