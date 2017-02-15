#######################################################
#
#Created by Markus on 12/11/2015.
#
#######################################################

##############################################
get_editor_id = () ->
	editor_id = Template.instance().editor_id.get()
	if not editor_id
		sAlert.error('Object does not have a editor_id')

	return editor_id

##############################################
get_textarea = () ->
	editor_id = get_editor_id()
	frm = $('#editor_'+editor_id)
	return frm


#########################################################
# select input
#########################################################

#########################################################
Template.select_input.helpers
	is_selected: (val) ->
		field = get_field_value Template.instance().data

		if !(field instanceof Array)
			field = [field]

		console.log field

		if val in field
			return "selected"

#########################################################
Template.select_input.events
	'change .post-field': (event) ->
		target = event.target
		value = target.options[target.selectedIndex].value;
		field = event.target.id
		value = event.target.value
		method = this.method
		collection = this.collection_name
		item_id = this.item_id

		Meteor.call method, collection, item_id, field, value, undefined,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success("Updated field: " + field)


#########################################################
# basic input
#########################################################

#########################################################
Template.basic_input.helpers
	value: () ->
		return get_field_value(this)

#########################################################
Template.basic_input.events
	'change .post-field': (event) ->
		field = event.target.id
		value = event.target.value
		method = this.method
		collection = this.collection_name
		item_id = this.item_id

		Meteor.call method, collection, item_id, field, value, undefined,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success("Updated field: " + field)

#########################################################
# Text
#########################################################

#########################################################
Template.text_input.helpers
	value: () ->
		return get_field_value(this)

	is_selected: () ->
		return ""

	options: () ->
		return []

#########################################################
Template.text_input.events
	'change .post-field': (event) ->
		field = event.target.id
		value = event.target.value
		method = this.method
		collection = this.collection_name
		item_id = this.item_id

		Meteor.call method, collection, item_id, field, value, undefined,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success("Updated field: " + field)

#########################################################
# summernote input
#########################################################

##############################################
Template.summernote.onCreated ->
	editor_id = Math.floor(Math.random()*10000000)
	this.editor_id = new ReactiveVar(editor_id)

#######################################################
Template.summernote.onRendered () ->
	conf =
		height: 200
		prettifyHtml: true
		codemirror:
			theme: 'monokai'

	value = get_field_value(this.data)
	area = get_textarea()
	res = area.summernote(conf)
	res.summernote('code', value)

##############################################
Template.summernote.helpers
	editor_id: ->
		return get_editor_id()

	value: ->
		return get_field_value(this)

	session: ->
		conf =
			height: 200
			prettifyHtml: false
			codemirror:
				theme: 'monokai'

		value = get_field_value(this)
		area = get_textarea()
		res = area.summernote(conf)
		res.summernote('code', value)


#######################################################
Template.summernote.events
	'click #save': ( event, template ) ->
		content = get_textarea().summernote('code')

		collection = this.collection_name
		method = this.method
		field = this.field
		item = this.item_id
		type = 'string'

		Meteor.call method, collection, item, field, content, type,
			(err, rsp)->
				if err
					sAlert.error('Changes not saved!' + err)
				else
					sAlert.success('Changes saved!')

