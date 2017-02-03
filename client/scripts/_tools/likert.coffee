Template.likert_item.onCreated ->
	if this.data.from is undefined
		this.data.from = 1

	if this.data.to is undefined
		this.data.to = 5

Template.likert_item.helpers
	selected: (val) ->
		return 'btn-theme'

		if val == this.value
			return 'btn-theme'

	levels: () ->
		return [this.from..this.to]

Template.likert_item.events
	'click .likert_value': (event, template) ->
		item_id = 0
		field = ''

		Meteor.call 'update_field', item_id, field, this,
			(err, res)->
				if(err)
					sAlert.error(err)
					console.log(err)
				if(res)
					sAlert.success('Changes saved! Thx!')
