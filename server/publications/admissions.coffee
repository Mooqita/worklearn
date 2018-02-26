#######################################################
#
#	Mooqita publications for collaborators
# Created by Markus on 26/10/2017.
#
#######################################################

#######################################################
# item header
#######################################################

###############################################################################
_admission_fields =
	fields:
		c: 1
		i: 1
		u: 1
		r: 1


#######################################################
Meteor.publish "admissions", (parameter) ->
	pattern =
		query: Match.Optional(String)
		collection_name: String
		item_id: String
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
	if not user_id
		throw Meteor.Error("Not permitted.")

	collection_name = parameter.collection_name
	item_id = parameter.item_id

	collection = get_collection_save collection_name
	item = collection.findOne item_id

	if not item
		throw Meteor.Error("Not permitted.")

	page = parameter.page || 0
	limit = parameter.size || 10
	limit = if limit < 100 then limit else 100

	options = _admission_fields
	options["skip"] = page * limit
	options["limit"] = limit

	crs = get_admissions IGNORE, IGNORE, collection, item, options
	log_publication crs, user_id, "admissions"

	return crs


#######################################################
Meteor.publish "my_admissions", () ->
	user_id = this.userId

	crs = get_my_admissions IGNORE, IGNORE, IGNORE, _admission_fields
	log_publication crs, user_id, "my_admissions"

	return crs

#######################################################
Meteor.publish "collaborator", (user_id) ->
	check user_id, String

	if not user_id
		throw Meteor.Error("Not permitted.")

	options =
		fields:
			given_name : 1
			family_name : 1
			middle_name : 1
			user_id: 1
			avatar: 1

	profile_cursor = get_documents user_id, OWNER, "profiles", {}, options
	admission_cursor = get_admissions user_id, OWNER, "profiles", IGNORE
	result = [profile_cursor, admission_cursor]

	log_publication result, user_id, "collaborators"

	return result

