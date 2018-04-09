################################################################
#
# Markus 12/10/2017
#
################################################################

###############################################
Meteor.methods
	add_admissions: (collection_name, item_id, admissions) ->
		#TODO: This is not working do we need it? Or something similar?
		return []

		check collection_name, String
		check item_id, String
		check admissions, [{email:String, role:String}]

		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		collection = get_collection_save collection_name
		item = collection.findOne item_id

		return gen_admissions collection_name, item, admissions

