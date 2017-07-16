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
	Roles.setUserRoles admin, ['admin', 'db_admin', 'editor', 'challenge_designer']
	a_id = gen_profile admin

	msg = "admin added " + user.email + " " +a_id
	loig_event msg, event_testing, event_info
	return admin

#####################################################
@initialize_database = () ->
	admin = Accounts.findUserByEmail('admin@worklearn.com')
	if not admin
		add_admin()
	else
		filter =
			owner_id: admin._id
		profile = Profiles.findOne filter
		if not profile
			gen_profile admin._id

	return true

#####################################################
# start up
#####################################################
Meteor.startup () ->
	try
		initialize_database()
	catch e
		msg = String(e)
		log_event msg, event_testing, event_err

	index =
		owner_id: 1
	Challenges._ensureIndex index
	Solutions._ensureIndex index
	Reviews._ensureIndex index
	Feedback._ensureIndex index
	Profiles._ensureIndex index
	Messages._ensureIndex index
	Posts._ensureIndex index

	index =
		parent_id: 1
	Challenges._ensureIndex index
	Solutions._ensureIndex index
	Reviews._ensureIndex index
	Feedback._ensureIndex index
	Profiles._ensureIndex index
	Posts._ensureIndex index

	index =
		solution_id: 1
	Reviews._ensureIndex index
	Feedback._ensureIndex index

	index =
		challenge_id: 1
	Solutions._ensureIndex index
	Reviews._ensureIndex index
	Feedback._ensureIndex index

	index =
		content: "text"
		title: "text"
	Challenges._ensureIndex index
	Solutions._ensureIndex index
	Reviews._ensureIndex index
	Feedback._ensureIndex index
	Posts._ensureIndex index
