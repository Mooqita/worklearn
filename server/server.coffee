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

	admin = Accounts.createUser(user)
	Roles.setUserRoles(admin, ['admin', 'db_admin', 'editor'])

	console.log user.email
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
	try
		initialize_database()
	catch e
		console.log e

