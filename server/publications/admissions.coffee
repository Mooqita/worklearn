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

	'''user_ids = (i.member_id for i in admissions)

	filter =
		_id:
			$in: user_ids

	crs = Meteor.users.find filter, options'''


	log_publication "Admissions", crs, {},
			{}, "admissions", user_id
	return crs
