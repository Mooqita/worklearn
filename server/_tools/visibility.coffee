#######################################################
@field_visible = (collection, id, field, user_id) ->
	check(id, String)
	check(field, String)
	check(collection, String)

	roles = ['all']
	if user_id
		check(user_id, String)
		user = Meteor.users.findOne(user_id)

		if __is_owner_publish collection, id, user_id
			roles.push 'owner'

	if user
		roles.push user.roles ...
		roles.push 'anonymous'

	filter =
		role:
			$in: roles
		field: field
		collection: collection

	permissions = Permissions.find(filter)

	if permissions.count() == 0
		console.log('No read permission found for: ' + roles)
		return false

	for permission in permissions.fetch()
		if __action_permitted permission, 'read'
			return true

	throw false


#######################################################
@filter_visible_to_user = (user_id, restrict={}) ->
	filters = []
	roles = ["all"]

	if user_id
		# find all user roles
		roles.push "anonymous"
		user = Meteor.users.findOne user_id
		roles.push user.roles ...

		# adding a filter for all posts we authored
		f2 =
			#post_group: group_name
			owner_id: user._id

		for k,v of restrict
			f2[k] = v

		filters.push f2

	# adding a filter for all elements our current role allows us to see
	f1 =
		deleted:
			$ne:
				true
		visible_to:
			$in: roles

	for k,v of restrict
		f1[k] = v

	filters.push f1

	filter =
		$or: filters

	return filter