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

		if !Roles.userIsInRole(user._id, 'editor')
			throw new Meteor.Error('Not permitted.')

		post =
			index: index
			parent_id: parent_id
			template_id: template_id
			single_parent: false
			group_name: group_name
			visible_to: "editor"

		id = store_document_unprotected collection, post

		msg = "Post added: " + JSON.stringify post, null, 2
		log_event msg, event_create, event_info

		return id
