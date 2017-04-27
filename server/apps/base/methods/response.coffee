################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	add_response: (parameters) ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		id = save_document Responses, parameters

		console.log "Response added: " + JSON.stringify(parameters, null, 2);
		return id

	#######################################################
	summarise_field: (template_id, field) ->
		check template_id, String
		check field, String

		match =
		  $match:
		    template_id: template_id

		group =
			$group:
				_id: '$'+field
				result:
					$sum: 1

		res = Responses.aggregate match, group
		return res

	backup_responses: () ->
		data = export_data(Responses)
		return data
