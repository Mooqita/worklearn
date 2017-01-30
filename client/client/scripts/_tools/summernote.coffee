#######################################################
#
#Created by Markus on 12/11/2015.
#
#######################################################

#######################################################
load_content = (self) ->
	collection = global[self.collection_name]
	item = collection.findOne(self.item_id)
	return item[self.field]

#######################################################
Template.summernote.rendered = () ->
	conf =
		height: 200,
		focus: true

	value = load_content(this.data)
	name = '#' + this.data.field + '_editor'
	res = $(name).summernote(conf)

	console.log(res)
	console.log(value)

	res.summernote('code', value)

#######################################################
Template.summernote.events
	'click #save': ( event, template ) ->
		name = '#' + this.field + '_editor'
		content = $(name).summernote('code')

		console.log content

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

