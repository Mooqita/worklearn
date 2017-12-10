#######################################################
#
#	Mooqita publications for collaborators
# Created by Markus on 26/10/2017.
#
#######################################################

#######################################################
# item header
#######################################################

#######################################################
_collaborator_fields =
	fields:
		emails: 1

#######################################################
Meteor.publish "admissions", (parameter) ->
	pattern =
		query: Match.Optional(String)
		collection_name: String
		item_id: String
		page: Number
		size: Number
	check parameter, pattern

	collection_name = parameter.collection_name
	item_id = parameter.item_id
	user_id = this.userId

	if not user_id
		throw Meteor.Error("Not permitted.")

	collection = get_collection_save collection_name
	item = collection.findOne item_id

	if not item
		throw Meteor.Error("Not permitted.")

	crs = get_admissions item, parameter.page, parameter.size

	log_publication "Admissions", crs, {},
			{}, "admissions", user_id
	return crs


#######################################################
Meteor.publish "collaborators", (parameter) ->
	pattern =
		query: Match.Optional(String)
		collection_name: String
		item_id: String
		page: Number
		size: Number
	check parameter, pattern

	collection_name = parameter.collection_name
	item_id = parameter.item_id
	user_id = this.userId

	if not user_id
		throw Meteor.Error("Not permitted.")

	collection = get_collection_save collection_name
	item = collection.findOne item_id

	if not item
		throw Meteor.Error("Not permitted.")

	user_ids = new Set()

	##############################################
	# retrieving admissions
	##############################################

	##############################################
	admission_cursor = get_admissions item, parameter.page, parameter.size
	admission_cursor.forEach (entry) ->
		user_ids.add entry.member_id

	user_ids = Array.from(user_ids)

	##############################################
	# retrieving profiles
	##############################################

	##############################################
	filter =
		owner_id:
			$in: user_ids

	options =
		fields:
			given_name : 1
			family_name : 1
			middle_name : 1
			owner_id: 1
			avatar: 1

	profile_cursor = Profiles.find filter, options

	log_publication "Multiple Cursor", null, {},
			{}, "collaborators", user_id

	return [admission_cursor, profile_cursor]
