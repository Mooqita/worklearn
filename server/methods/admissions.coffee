################################################################
#
# Markus 12/10/2017
#
################################################################

###############################################
Meteor.methods
	add_admissions: (collection_name, item_id, admissions) ->
		check collection_name, String
		check item_id, String
		check admissions, [{email:String, role:String}]

		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		return gen_admissions collection_name, item_id, admissions

