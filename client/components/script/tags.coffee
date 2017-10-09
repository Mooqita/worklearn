#############################################################
#
#############################################################

#############################################################
Template.tags.onCreated ->
	value = get_field_value this


	this.tags = new ReactiveVar({})

#########################################################
Template.tags.events
	"change .edit-field": (event) ->
		field = event.target.id
		value = event.target.value
		method = this.method
		collection = this.collection_name
		item_id = this.item_id

		Meteor.call method, collection, item_id, field, value, undefined,
			(err, res) ->
				if err
					sAlert.error("Tags input error: " + err)
					console.log err
				if res
					sAlert.success("Updated: " + field)


#############################################################
Template.tags.helpers
	tag_line: () ->
		value = get_field_value this
		return value

	tags: () ->
		value = get_field_value this
		value = value.replace(/ /g, "")
		tags = value.split ","
		return tags

