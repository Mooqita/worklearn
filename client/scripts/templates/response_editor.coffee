########################################
# response
########################################

########################################
get_index = () ->
	index = FlowRouter.getParam("index")
	if not index
		index = Session.get "current_page"

	return index


########################################
get_template_id = () ->
	id = FlowRouter.getParam("template_id")
	if not id
		id = Session.get "current_template"

	return id


#######################################
#
# response dashboard
#
########################################

########################################
Template.response_dashboard.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe "responses"

########################################
Template.response_dashboard.helpers
	response: () ->
		id = FlowRouter.getParam("response_id")
		res = Responses.findOne(id)
		return res

	responses: () ->
		filter =
			parent_id: ""

		mod =
			sort:
				deleted: 1
				index: 1
				view_order: 1

		res = Responses.find(filter, mod)
		return res


########################################
Template.response_item.onCreated ->
	this.file_data = new ReactiveVar("")
	this.file_name = new ReactiveVar("")
	this.expanded = new ReactiveVar(false)

########################################
Template.response_item.helpers
	response_url: () ->
		return "/response_dashboard/"+this._id

	has_children: (parent) ->
		filter =
			parent_id: parent._id

		res = Responses.find(filter).count()
		return res

	expanded: () ->
		return Template.instance().expanded.get()

	children: (parent) ->
		filter =
			parent_id: parent._id

		mod =
			sort:
				index:1

		list = Responses.find(filter, mod)
		return list

	name_or_title: () ->
		if this.name
			return this.name

		return this.title

	file_data: () ->
		return Template.instance().file_data.get()

	file_name: () ->
		return Template.instance().file_name.get()

########################################
Template.response_item.events
	"click #expand": () ->
		ins = Template.instance()
		s = not ins.expanded.get()
		ins.expanded.set(s)

	"click #delete_response": () ->
		field = "deleted"
		collection_name = "Responses"
		value = get_field_value(this, field, this._id, collection_name)
		value = if value then false else true
		item_id = this._id

		Meteor.call "set_field", collection_name, item_id, field, value, undefined,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success("Updated: " + field)

	"click #add_response_with_parent": () ->
		Meteor.call "add_response", "", 1, this._id,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.info("response added")

	"click #save_response": () ->
		self = this
		inst = Template.instance()

		Meteor.call "save_response", self._id,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					inst.file_data.set res
					inst.file_name.set self._id+".json"


########################################
#
# Response editor
#
########################################

########################################
Template.response_editor.onCreated ->
	this.loaded_template = new ReactiveVar(0)
	this.loaded_response = new ReactiveVar(0)

	self = this
	self.autorun () ->
		rn = self.data._id
		tn = self.data.template_id

		self.subscribe "response_by_id", rn,
			onReady: () ->
				self.loaded_response.set(true)

		self.subscribe "template_by_id", tn,
			onReady: () ->
				self.loaded_template.set(true)

########################################
Template.response_editor.helpers
	template_id: ->
		return this.template_id

	template: ->
		template = get_template this.template_id
		return template

	data_loaded: () ->
		inst = Template.instance()

		done = inst.loaded_template.get() && inst.loaded_response.get()
		return done

	response: ->
		return this

########################################
#
########################################

########################################
Template.response_creator.onCreated ->
	self = this
	self.loaded = new ReactiveVar(false)
	self.autorun () ->
		if not self.response
			index = FlowRouter.getParam("index")
			template_id = FlowRouter.getParam("template_id")
			self.subscribe "response", template_id, index,
				onReady: () ->
					self.loaded.set(true)
			return

		self.subscribe "response", self.response._id,
			onReady: () ->
				self.loaded.set(true)


########################################
Template.response_creator.helpers
	template_id: ->
		return FlowRouter.getParam("template_id")

	template: ->
		template_id = FlowRouter.getParam("template_id")
		template = get_ template_id
		return template

	loaded: ->
		res = Template.instance().loaded.get()
		return res

	response: ->
		template_id = FlowRouter.getParam("template_id")
		index = get_index()

		filter =
			template_id: template_id
			owner_id: Meteor.userId()
			index: index

		response = Responses.findOne(filter)
		return response

########################################
# add_response
########################################

########################################
Template.add_response.onCreated ->
	index = get_index()
	template_id = FlowRouter.getParam("template_id")
	Meteor.call "add_response", template_id, index,
		(err, res) ->
			if err
				sAlert.error err
			else
				sAlert. success "Response added"

#########################################################
# Edit post toggle
#########################################################

#########################################################
Template._edit_toggle.events
	'click #edit': () ->
		ed = Session.get("editing_response")

		if ed == this._id
			Session.set("editing_response", "")
			return

		console.log this._id
		Session.set("editing_response", this._id)
