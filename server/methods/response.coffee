################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	add_response: (template_id="", index=1, parent_id="") ->
		check template_id, String
		check parent_id, String
		check index, Match.OneOf String, Number

		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		hit =
			parent_id: parent_id
			template_id: template_id
			owner_id: Meteor.userId()
			index: index
			view_order: 1

		id = Responses.insert hit
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
		data = exportData(Responses)
		return data
