#######################################################
#
# Created by Markus
#
#######################################################

################################################################
Meteor.methods
	add_post: (template_id, parent_id, group_name, index) ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if can_edit Posts, WILDCARD, user
			throw new Meteor.Error('Not permitted.')

		post =
			index: index
			parent_id: parent_id
			template_id: template_id
			group_name: group_name

		id = store_document_unprotected collection, post, user

		msg = "Post added: " + JSON.stringify post, null, 2
		log_event msg, event_create, event_info

		return id
