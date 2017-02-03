#########################################################
# Landing
#########################################################

#########################################################
Template.landing.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe 'posts', 'post'
		self.subscribe 'posts', 'publication'

#########################################################
Template.landing.events
	'click #add_post': ()->
		e = $('#template_select')[0]
		val = e.options[e.selectedIndex].value

		Meteor.call 'add_post', val,
			(err, res) ->
				if err
					sAlert.error(err)

#########################################################
Template.landing.helpers
	publications: ->
		filter =
			template: 'publication'

		mod =
			sort:
				pub_year:1

		return Posts.find(filter, mod)

	posts: ->
		filter =
			template: 'post'

		mod =
			sort:
				pub_year:1

		return Posts.find(filter, mod)

#########################################################
# Post
#########################################################

#########################################################
Template._post.events
	'click #remove_post': ()->
		Meteor.call 'set_post_field', '', this._id, 'deleted', true, undefined,
			(err, res) ->
				if err
					sAlert.error(err)

	'click #reinstate_post': ()->
		Meteor.call 'set_post_field', '', this._id, 'deleted', false, undefined,
			(err, res) ->
				if err
					sAlert.error(err)

	'change #visible_select': (event) ->
		obj = event.target
		value = obj.options[obj.selectedIndex].value
		console.log(value)

		Meteor.call 'set_post_visibility', this._id, value,
			(err, res) ->
				if err
					sAlert.error(err)

	'change #template_select': (event) ->
		obj = event.target
		value = obj.options[obj.selectedIndex].value

		Meteor.call 'set_post_field', '', this._id, 'template', value, undefined,
			(err, res) ->
				if err
					sAlert.error(err)

#########################################################
Template._post.helpers
	is_visible: (val) ->
		if val in this.visible_to
			return "selected"

	is_template: (val) ->
		if val == this.template
			return "selected"

#########################################################
# Paper
#########################################################

#########################################################
Template.publication.events
	'click #remove_paper': (event) ->
		Meteor.call 'set_post_field', '', this._id, 'paper', '', undefined,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.success('Paper cleared')

	'click #remove_figure': (event) ->
		Meteor.call 'set_post_field', '', this._id, 'figure', '', undefined,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.success('Figure cleared')

	'change .post-field': (event) ->
		console.log(event.target.id)
		data = event.target.value
		field = event.target.id

		Meteor.call 'set_post_field', '', this._id, field, data, undefined,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.success(field + ' updated')

#########################################################
# Post
#########################################################

#########################################################
Template.post.events
	'click #remove_figure': (event) ->
		Meteor.call 'set_post_field', '', this._id, 'figure', '', undefined,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.success('Figure cleared')

	'change .post-field': (event) ->
		console.log(event.target.id)
		data = event.target.value
		field = event.target.id

		Meteor.call 'set_post_field', '', this._id, field, data, undefined,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.success(field + ' updated')

