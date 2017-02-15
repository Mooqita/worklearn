################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	add_hit: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		hit =
			owner_id: Meteor.userId()

		id = Hits.insert hit
		return id
