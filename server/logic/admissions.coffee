#######################################################
#
# Created by Markus
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
@gen_admission = (collection, item, user, role) ->
	if typeof collection != "string"
		collection = collection._name

	if typeof item != "string"
		item = item._id

	if typeof user != "string"
		user = user._id

	if typeof role != "string"
		throw "Role needs to be a string found: " + role

	filter =
		c: collection
		i: item
		u: user
		r: role

	admission = Admissions.findOne filter
	if admission
		msg = "Admission already exists."
		log_event msg
		return item._id

	item_id = Admissions.insert filter
	return item_id


#######################################################
@remove_admissions = (collection, item_ids, user) ->
	filter =
		c: get_collection_name(collection)
		i:
			$in: item_ids

	count = Admissions.remove filter

	msg = count + " admissions removed by: " + get_user_mail(user)
	log_event msg, event_logic, event_info

	return count

