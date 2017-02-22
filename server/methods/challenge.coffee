################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	add_challenge: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if !Roles.userIsInRole(user._id, 'editor')
			throw new Meteor.Error('Not permitted.')

		challenge =
			owner_id: Meteor.userId()
			content: ''

		id = Challenges.insert challenge
		return id
