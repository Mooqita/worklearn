#######################################################
#
#Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
@modify_field_unprotected = (collection_name, id, field, value) ->
	s = {}
	s[field] = value
	s['modified'] = new Date

	mod =
		$set:s

	colllection = get_collection collection_name
	n = colllection.update(id, mod)

	msg = 'Changed ' + field + ' of ' +
			collection_name + ':' + id + ' to ' +
			value.toString().substr(0, 50)

	console.log(msg)

	return n


#######################################################
@modify_field = (collection_name, id, field, value) ->
	deny_action_save('modify', collection_name, id, field)

	check value, Match.OneOf String, Number, Boolean

	res = modify_field_unprotected collection_name, id, field, value

	if typeof value == "string"
		predaid_add_text collection_name, id, field

	return res


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
			avatar: 1
			resume: 1
			content: 1
			deleted: 1
			material: 1
			abstract: 1
			owner_id: 1
			parent_id: 1
			visible_to: 1
			view_order: 1
			group_name: 1
			template_id: 1
			type_identifier: 1

#######################################################
@visible_fields = (collection, user_id, filter) ->
	public_fields = _collection_headers[collection]
	owner = false

	if filter.owner_id
		if filter.owner_id == user_id
			owner = true

	if not owner
		return public_fields

	roles = ['all']
	if owner
		roles.push 'owner'

	if user_id
		user = Meteor.users.findOne(user_id)

	if user
		roles.push user.roles ...
		roles.push 'anonymous'

	res = {}
	common_fields = public_fields["fields"]
	edit_fields = Permissions.find({}, {fields:{field:1}}).fetch()
	all_fields = new Set(Object.keys(common_fields))

	for field in edit_fields
		all_fields.add field["field"]

	for field of all_fields
		filter =
			role:
				$in: roles
			field: field
			collection: collection

		permissions = Permissions.find(filter)

		if permissions.count() == 0
			continue

		for permission in permissions.fetch()
			if action_permitted permission, 'read'
				res[field["field"]] = 1

	mod =
		fields: res

	return mod


