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

#######################################################
load_content = (self) ->
	collection = global[self.collection_name]
	item = collection.findOne(self.item_id)
	return item[self.field]

##############################################
Template.summernote.onCreated ->
	editor_id = Math.floor(Math.random()*10000000)
	this.editor_id = new ReactiveVar(editor_id)

#######################################################
Template.summernote.rendered = () ->
	conf =
		height: 200,
		focus: true

	value = load_content(this.data)
	area = get_textarea()
	res = area.summernote(conf)
	res.summernote('code', value)

##############################################
Template.summernote.helpers
	editor_id: ->
		return get_editor_id()

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

