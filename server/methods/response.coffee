################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	add_response: (challenge_id, index) ->
		check challenge_id, String
		check index, Match.OneOf String, Number

		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		hit =
			challenge_id: challenge_id
			owner_id: Meteor.userId()
			index: index

		id = Responses.insert hit
		return id
