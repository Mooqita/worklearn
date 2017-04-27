Template.likert_item.onCreated ->
	f = this.data.from
	if f is undefined
		f = 1
	t = this.data.to
	if t is undefined
		t = 7

	this.from = new ReactiveVar(f)
	this.to = new ReactiveVar(t)


Template.likert_item.helpers
	selected: (val) ->
		self = Template.instance().data
		value = get_field_value(self)
		if val == value
			return 'btn-theme'

	levels: () ->
		f = Template.instance().from.get()
		t = Template.instance().to.get()
		res = [f..t]

		return res

Template.likert_item.events
	'click .likert_value': (event, template) ->
		value = Number(event.target.innerText)
		self = Template.instance().data
		item_id = self.item_id
		method = self.method
		collection = self.collection_name
		item_id = self.item_id
		field = self.field

		Meteor.call method, collection, item_id, field, value,
			(err, res)->
				if(err)
					sAlert.error(err)
				if res
					sAlert.success("Updated: " + field)
