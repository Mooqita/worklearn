################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	add_response: (collection_name, parameters) ->
		collection = get_collection_save collection_name
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		id = store_document collection, parameters

		msg = "Response added: " + JSON.stringify parameters, null, 2
		log_event msg, event_create, event_info

		return id

	#######################################################
	summarise_field: (collection_name, field) ->
		collection = get_collection_save collection_name
		check field, String

		match =
		  $match:
		    template_id: template_id

		group =
			$group:
				_id: '$'+field
				result:
					$sum: 1

		res = collection.aggregate match, group
		return res

	backup_responses: (collection_name) ->
		collection = get_collection_save collection_name
		data = export_data(collection)
		return data
