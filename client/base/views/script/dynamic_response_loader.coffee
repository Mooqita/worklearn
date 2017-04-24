########################################
#
# Response Broker
#
########################################

########################################
_local_template = 1
_response = 2
_error = -1

########################################
_get_response = (self) ->
	response_id = FlowRouter.getParam("response_id")
	filter = null

	if self.response
		filter =
			_id: self.response._id
	else if response_id
		filter =
			_id: response_id
	else
		index = FlowRouter.getParam("index")
		template_id = FlowRouter.getParam("template_id")
		filter =
			template_id: template_id
			owner_id: Meteor.userId()
			index: index

	response = Responses.findOne(filter)
	return response

########################################
Template.dynamic_response_loader.onCreated ->
	self = this
	self.loaded = new ReactiveVar(0)

	handler =
		onStop:(err) ->
			if err
				sAlert.error err
			self.loaded.set _error

		onReady:() ->
			response = _get_response(self)
			self.loaded.set _response

	self.autorun () ->
		response_id = FlowRouter.getParam("response_id")
		template_id = FlowRouter.getParam("template_id")
		index = FlowRouter.getParam("index")

		if self.response
			filter =
				_id: self.response._id
		else if response_id
			filter =
				_id: response_id
		else if template_id and index
			filter =
				index: index
				template_id: template_id
		else
			self.loaded.set _local_template
			return

		self.subscribe "responses", filter, false, "dynamic_response_loader", handler

########################################
Template.dynamic_response_loader.helpers
	loaded: ->
		loaded = Template.instance().loaded.get()

		if loaded == _local_template
			return true

		else if loaded == _response
			response = _get_response(this)
			return response.loaded

		return false

	response: ->
		loaded = Template.instance().loaded.get()

		if loaded == _local_template
			return true

		return _get_response(this)

	template_id: () ->
		loaded = Template.instance().loaded.get()

		if loaded == _local_template
			if not this.content instanceof Function
				return "ER_404"

			t_id = this.content()
			if t_id == "dynamic_response_loader"
				return "CYCLE_LOOP"

			return this.content()

		else if loaded == _response
			response = _get_response(this)
			return response.template_id

		else if loaded == _error
			return "ER_404"

		return ""

	create: ->
		index = FlowRouter.getParam("index")
		if index
			return true
		return false

########################################
# add_response
########################################

########################################
Template.add_response.onCreated ->
	index = _get_index()
	template_id = FlowRouter.getParam("template_id")
	param =
		template_id: template_id
		index: index

	Meteor.call "add_response", param,
		(err, res) ->
			if err
				sAlert.error err
			else
				sAlert. success "Response added"

