#######################################################
#
#######################################################

#######################################################
@gen_admissions = (collection_name, item_id, admissions) ->
	if not collection_name
		throw new Meteor.Error "collection_name need to be defined"

	if not item_id
		throw new Meteor.Error "Item need to be defined"

	if not admissions
		throw new Meteor.Error "Mails need to be defined"

	collection = get_collection_save collection_name
	item = collection.findOne item_id

	users = []
	for a in admissions
		user = Accounts.findUserByEmail a.email
		if not user
			continue

		gen_admission collection_name, item, user, a.role
		users.push user

	return users


#######################################################
@gen_admission = (collection_name, item, user, role) ->
	if not item
		throw new Meteor.Error "Item need to be defined"

	if not user
		throw new Meteor.Error "User need to be defined"

	if not role
		throw new Meteor.Error "Role need to be defined"

	admission =
		collection_name: collection_name
		resource_id: item._id
		member_id: user._id
		role: role

	item = Admissions.findOne admission
	if item
		return item._id

	item_id = Admissions.insert admission
	return item_id


#######################################################
@get_admissions = (item, skip, limit) ->
	limit = if limit < 100 then limit else 100

	filter =
		resource_id: item._id

	options =
		fields:
			member_id: 1
		skip: skip
		limit: limit

	crs = Admissions.find(filter, options)
	return crs