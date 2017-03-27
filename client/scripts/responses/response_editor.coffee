########################################
# response
########################################

########################################
_get_index = () ->
	index = FlowRouter.getParam("index")
	if not index
		index = Session.get "current_page"

	return index


########################################
_get_template_id = () ->
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
		self.subscribe "responses", true

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
import { saveAs } from 'file-saver'

Template.response_dashboard.events
	"click #export_responses": () ->
		Meteor.call "backup_responses",
			(err, res) ->
				if err
					sAlert.error(err)
				else
					blob = convertBase64ToBlob res
					saveAs blob, "responses.zip"

	"click #add_response": () ->
		Meteor.call "add_response", "", 1, "",
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.info("response added")


########################################
# Response Item
########################################

########################################
Template.response_item.onCreated ->
	this.file_data = new ReactiveVar("")
	this.file_name = new ReactiveVar("")
	this.expanded = new ReactiveVar(false)

########################################
Template.response_item.helpers
	response_url: () ->
		return get_response_url this._id, true

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
	"click #expand": (event) ->
		id = this._id
		ins = Template.instance()

		if ins.data._id != id
			return

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


########################################
#
# Response editor
#
########################################

########################################
Template.response_editor.onCreated ->
	this.loaded_response = new ReactiveVar(0)

	self = this
	self.autorun () ->
		rn = self.data._id

		self.subscribe "response_by_id", rn, false,
			onReady: () ->
				self.loaded_response.set(true)

########################################
Template.response_editor.helpers
	template_id: ->
		return this.template_id

	data_loaded: () ->
		inst = Template.instance()
		done = inst.loaded_response.get()
		return done

	response: ->
		return this

########################################
#
########################################

########################################
get_response = (self) ->
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
Template.response_creator.onCreated ->
	self = this
	self.loaded = new ReactiveVar(false)

	handler =
		onStop:(err) ->
			if err
				sAlert.error err
			self.loaded.set(true)

		onReady:() ->
			self.loaded.set true

	self.autorun () ->
		response_id = FlowRouter.getParam("response_id")

		if self.response
			self.subscribe "response_by_id", self.response._id, false, handler
		else if response_id
			self.subscribe "response_by_id", response_id, false, handler
		else
			index = FlowRouter.getParam("index")
			template_id = FlowRouter.getParam("template_id")
			self.subscribe "response_by_template", template_id, index, false, handler

########################################
Template.response_creator.helpers
	template_id: ->
		response = get_response(this)
		return response.template_id

	loaded: ->
		res = Template.instance().loaded.get()
		return res

	create: ->
		index = FlowRouter.getParam("index")
		if index
			return true
		return false

	response: ->
		return get_response(this)

########################################
# add_response
########################################

########################################
Template.add_response.onCreated ->
	index = _get_index()
	template_id = FlowRouter.getParam("template_id")
	Meteor.call "add_response", template_id, index,
		(err, res) ->
			if err
				sAlert.error err
			else
				sAlert. success "Response added"

#########################################################
# Edit tool toggle
#########################################################

#########################################################
Template._edit_toggle.events
	'click #edit': () ->
		ed = Session.get("editing_response")

		if ed == this._id
			Session.set("editing_response", "")
			return

		Session.set("editing_response", this._id)


#########################################################
# Edit tools
#########################################################

#########################################################
Template._edit_tools.helpers
	is_visible: (val) ->
		if val in this.visible_to
			return "selected"

	is_template: (val) ->
		if val == this.template
			return "selected"

	is_group: (val) ->
		if val == this.group
			return "selected"

	templates: () ->
		return find_template_names()

	parents: () ->
		filter = {}
		mod =
			fields:
				_id: 1
				title: 1

		list = Responses.find(filter, mod).fetch()
		groups = [{value:"", label:"Select a parent"}]
		groups.push ({value:x._id, label:x.title} for x in list)...

		return groups

