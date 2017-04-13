#####################################################
# Created by Markus on 23/10/2015.
#####################################################

class @PredaidTask
	constructor: (@removal_id, @payload, @task, @owner_id) ->
		@priority = 0
		@attempts = 0
		@locked_by = null
		@locked_at = null
		@last_error = null


#####################################################
#
#
#
# collection_name: Name of the collection the text to
#									 analyse can be found.
# item_id: 				 _id of the object that contains
# 								 the text.
# field: 					 the field name of the collection
#####################################################

#####################################################
@predaid_add_text = (collection_name, item_id, field) ->
	deny_action_save('read', collection_name, item_id, field)

	collection = get_collection collection_name

	item = collection.findOne item_id
	if not item
		throw new Meteor.Error "Item not found."

	user_id = Meteor.userId()
	removal_id = item.removal_id

	meta_data =
		owner_id: user_id
		collection_name: collection_name
		item_id: item_id
		field: field

	ds = new PredaidTask(removal_id, meta_data, "parse", user_id)
	set_id = PredaidTasks.insert(ds)
	removal_id = ds.removal_id

	return set_id


