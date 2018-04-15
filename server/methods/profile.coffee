################################################################
#
# Markus 1/23/2017
#
################################################################

###############################################
Meteor.methods
	add_profile: (param) ->
		check param.occupation, String
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		profile = Profiles.findOne user._id

		if profile
			throw new Meteor.Error "Profile already created"

		return gen_profile user
