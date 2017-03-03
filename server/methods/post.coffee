################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	add_post: (group_name) ->
		check group_name, String

		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if !Roles.userIsInRole(user._id, 'editor')
			throw new Meteor.Error('Not permitted.')

		post =
			template: "post"
			post_group: group_name
			owner_id: Meteor.userId()
			view_order: 0
			pub_year: 0
			parent: ""

		Posts.insert post

	set_post_visibility: (collection_name, item_id, field, data, type) ->
		__deny_action('modify', collection_name, item_id, field)
		check data, Match.OneOf(String, [String])

		if typeof data == 'string'
			data = [data]

		mod =
			$set:
				visible_to: data

		n = Posts.update(item_id, mod)
		return n

