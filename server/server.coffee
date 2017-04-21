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
	a_id = gen_profile admin._id

	console.log "admin:" + user.email + " " +a_id
	return admin

#####################################################
@initialize_database = () ->
	admin = Accounts.findUserByEmail('admin@worklearn.com')
	if not admin
		add_admin()
	else
		filter =
			owner_id: admin._id
			type_identifier: "profile"
		profile = Responses.findOne filter
		if not profile
			gen_profile admin._id

	return true

#####################################################
# start up
#####################################################
Meteor.startup () ->
	try
		initialize_database()
		index =
			owner_id: 1
			type_identifier: 1
		Responses._ensureIndex index

		index =
			parent_id: 1
			type_identifier: 1
		Responses._ensureIndex index

		index =
			text_index: "text"
			type_identifier: 1
		Responses._ensureIndex index

		index =
			item_id: 1
			field: 1
			collection_name: 1

		DBFiles._ensureIndex index
	catch e
		console.log e

