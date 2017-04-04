################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	add_response: (type_identifier, parameters) ->
		check type_identifier, String

		if not type_identifier
			throw new Meteor.Error "type_identifier must be a valid type got: " + type_identifier

		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		name = ""
		title = ""
		group_name = ""

		index = 1
		template_id = ""

		parent_id = ""
		single_parent = false

		if parameters.name
			check parameters.name, String
			name = parameters.name

		if parameters.title
			check parameters.title, String
			title = parameters.title

		if parameters.group_name
			check parameters.group_name, String
			group_name = parameters.group_name

		if parameters.index
			check parameters.index, Match.OneOf String, Number
			index = parameters.index

		if parameters.template_id
			check parameters.template_id, String
			template_id = parameters.template_id

		if parameters.parent_id
			check parameters.parent_id, String
			parent_id = parameters.parent_id

		if parameters.single_parent
			check parameters.single_parent, Boolean
			single_parent = parameters.single_parent

		if single_parent
			filter =
				parent_id: parent_id

			if Responses.findOne filter
				throw new Meteor.Error('Response for this parent already exists.')

		hit =
			group_name: group_name
			parent_id: parent_id
			title: title
			template_id: template_id
			type_identifier: type_identifier
			index: index
			single_parent: single_parent
			name: name

		id = insert_document Responses, hit
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
