Meteor.methods
	sign_in_worker: (worker_id) ->
		check worker_id, String

		if not worker_id
			user = null
		else
			filter =
				username: worker_id

			user = Meteor.users.findOne filter

		if not user
			ud =
				username: worker_id.toString(),
				password: worker_id.toString(),
				profile:
					avatar: null
					protected: true
					given_name: ''
					family_name: ''
					resume: ''

			user = Accounts.createUser ud
			Roles.setUserRoles(user, 'anonymous')
			console.log('user created')

		stampedLoginToken = Accounts._generateStampedLoginToken()
		Accounts._insertLoginToken user._id, stampedLoginToken

		console.log 'token created: ' + stampedLoginToken.toString()

		return stampedLoginToken
