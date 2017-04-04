#######################################################
_collection_headers =
	Templates:
		fields:
			_id : 1
			name: 1
			owner_id: 1
	Responses:
		fields:
			_id : 1
			name: 1
			index: 1
			title: 1
			deleted: 1
			owner_id: 1
			parent_id: 1
			visible_to: 1
			type_identifier: 1
			view_order: 1
			template_id: 1

#######################################################
@visible_fields = (collection, user_id, owner=false, header_only=false) ->
	if header_only
		return _collection_headers[collection]

	fields = Permissions.find {}, {fields:{field:1}}

	roles = ['all']
	if owner
		roles.push 'owner'

	if user_id
		user = Meteor.users.findOne(user_id)

	if user
		roles.push user.roles ...
		roles.push 'anonymous'

	res = {}

	for field in fields
		filter =
			role:
				$in: roles
			field: field["field"]
			collection: collection

		permissions = Permissions.find(filter)

		if permissions.count() == 0
			continue

		for permission in permissions.fetch()
			if __action_permitted permission, 'read'
				res[field] = 1

		mod =
			fields: res

	return mod


#######################################################
@visible_items = (user_id, owner=false, restrict={}) ->
	filter = []
	roles = ["all"]

	if user_id
		# find all user roles
		roles.push "anonymous"
		user = Meteor.users.findOne user_id
		roles.push user.roles ...

	if owner
		roles.push 'owner'

	# adding a filter for all elements our current role allows us to see
	filter =
		visible_to:
			$in: roles

	for k,v of restrict
		filter[k] = v

	if not owner
		filter["deleted"] =
			$ne:
				true

	if owner
		filter["owner_id"] = user_id

	return filter