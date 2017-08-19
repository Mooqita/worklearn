#####################################################
#
#Created by Markus on 26/10/2015.
#
#####################################################

#####################################################
@add_admin = () ->
	user = Accounts.findUserByEmail("admin@mooqita.org")

	if !user
		secret = Secrets.findOne()
		user =
			email: "admin@mooqita.org",
			password: secret.mkpswd,

		user = Accounts.createUser(user)
		Roles.setUserRoles user, ["admin", "db_admin", "editor", "challenge_designer"]

	filter =
		owner_id: user._id

	profile = Profiles.findOne filter

	if profile
		return profile._id

	profile_id = gen_profile admin, "student"

	msg = "admin added " + user.email + " " + profile_id
	loig_event msg, event_testing, event_info
	return profile_id


#####################################################
@initialize_database = () ->
	add_admin()
	run_tests()

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
