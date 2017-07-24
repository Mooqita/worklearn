################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	add_db_permission: (role, collection_name, field) ->
		user = Meteor.user()
		if !user
			throw new Meteor.Error('Not permitted.')

		if !Roles.userIsInRole(user._id, 'db_admin')
			throw new Meteor.Error('Not permitted.')

		check role, String
		check field, String
		check collection_name, String

# TODO: is this necessary?
#		secret = Secrets.findOne()

#		if not collection_name in secret.collections
#			throw new Meteor.Error 'Collection not present: ' + collection

		collection = get_collection_save collection_name
		if not collection
			throw new Meteor.Error 'Collection not present: ' + collection

#		role = Roles.findOne {name:role}
#		if not role
#			throw new Meteor.Error 'Role not present: ' + role

		filter =
			role: role
			field: field
			collection_name: collection._name

		mod =
			$set:
				modify: true
				read: true

		res = Permissions.upsert filter, mod
		return res

	remove_permission: (id) ->
		user = Meteor.user()
		if !user
			throw new Meteor.Error 'Not permitted.'

		if !Roles.userIsInRole user._id, 'db_admin'
			throw new Meteor.Error 'Not permitted.'

		check id, String

		Permissions.remove(id)
