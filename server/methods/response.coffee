################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	add_response: (challenge_template, index) ->
		check challenge_template, String
		check index, Match.OneOf String, Number

		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		hit =
			challenge_template: challenge_template
			owner_id: Meteor.userId()
			index: index

		id = Responses.insert hit
		return id
