#######################################################
#
# Created by Markus
#
#######################################################

################################################################
# TODO: this does not conform to mooqita's seperation of concern
# Moving logic and only keep security checks.
################################################################

################################################################
Meteor.methods
	add_post: (template_id, parent_id, group_name, index) ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if can_edit Posts, COLLECTION, user
			throw new Meteor.Error('Not permitted.')

		post =
			index: index
			parent_id: parent_id
			template_id: template_id
			group_name: group_name

		id = store_document_unprotected collection, post, user, true

		msg = "Post added: " + JSON.stringify post, null, 2
		log_event msg, event_create, event_info

		return id
