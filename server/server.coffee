#####################################################
#
#Created by Markus on 26/10/2015.
#
#####################################################

#####################################################
@add_admin = () ->
	secret = Secrets.findOne()
	user =
		email: 'admin@worklearn.com',
		password: secret.mkpswd,
		profile:
			avatar: ""
			protected: true
			given_name: 'Markus'
			family_name: 'Krause'

	admin = Accounts.createUser(user)
	console.log user.profile.given_name+' '+user.email

	Roles.setUserRoles(admin, ['admin', 'db_admin', 'editor'])
	return admin


#####################################################
@initialize_database = () ->
	if not Accounts.findUserByEmail('admin@worklearn.com')
		add_admin()

	return true

#####################################################
# start up
#####################################################
Meteor.startup () ->
	initialize_database()

