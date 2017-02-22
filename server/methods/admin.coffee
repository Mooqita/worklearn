################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	add_db_permission: (role, collection, field, types, actions) ->
		user = Meteor.user()
		if !user
			throw new Meteor.Error('Not logged in.')

		if !Roles.userIsInRole(user._id, 'db_admin')
			throw new Meteor.Error('Not permitted.')

		check(role, String)
		check(field, String)
		check(collection, String)
		check(types, [String])
		check(actions, [String])

		secret = Secrets.findOne()

		if not collection in secret.collections
			throw new Meteor.Error 'Collection not present: ' + collection

		if not get_collection(collection)
			throw new Meteor.Error 'Collection not present: ' + collection

		filter =
			role: role
			field: field
			collection: collection

		mod =
			$set:
				types: types
				actions: actions

		res = Permissions.upsert filter, mod
		return res

	remove_permission: (id) ->
		user = Meteor.user()
		if !user
			throw new Meteor.Error('Not logged in.')

		if !Roles.userIsInRole(user._id, 'db_admin')
			throw new Meteor.Error('Not permitted.')

		check(id, String)

		Permissions.remove(id)
