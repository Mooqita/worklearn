################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	add_template: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if !Roles.userIsInRole(user._id, 'editor')
			throw new Meteor.Error('Not permitted.')

		template =
			owner_id: Meteor.userId()
			code: ""

		id = Templates.insert template
		return id
