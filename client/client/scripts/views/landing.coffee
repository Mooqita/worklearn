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
		console.log(val)

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
# Paper
#########################################################

#########################################################
Template.publication.events
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

