#########################################################
# Landing
#########################################################

#########################################################
Template.landing.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe 'posts'
		self.subscribe 'posts', 'frontpage'

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
	has_group: (group) ->
		filter =
			post_group: group
		has = Posts.find(filter).count() > 0
		return has

	groups: () ->
		filter = {}
		mod =
			sort:
				post_group: 1
				fields:
					post_group: true
		func = (x)->
			return x.post_group;

		list = Posts.find(filter, mod).fetch().map(func)
		groups = _.uniq(list, true);
		return groups

	posts: (group) ->
		filter =
			post_group: group
		mod =
			sort:
				view_order:1
		return Posts.find(filter, mod)


