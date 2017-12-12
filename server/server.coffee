#####################################################
#
# Created by Markus on 26/10/2015.
#
#####################################################


#####################################################
_handle_startup_setting = () ->
	# make sure all indices are created
	_initialize_indices()
	_check_environment_variables()

	# The rest only works with a settings file and on localhost.
	# For security reasons we do not create default admin access.
	if not Meteor.settings
		return

	if not get_environment()=="local"
		return

	# add an admin if on localhost
	if Meteor.settings.admin
		param = Meteor.settings.admin
		_add_admin param.email, param.password

	# set default permissions if necessary
	if Meteor.settings.init_default_permissions && (Meteor.settings.init_default_permissions == true)
		_initialize_permissions()

	# add test data
	if Meteor.settings.init_test_data
		_initialize_database()


#####################################################
# Prepare indices
#####################################################

#####################################################
_initialize_indices = ()->
	msg = "Validating MongoDB indices"
	log_event msg

	index =
		resource_id: 1
		consumer_id: 1
		role: 1
	Admissions._ensureIndex index

	index =
		collection_name: 1
		role: 1
	Permissions._ensureIndex index

	index =
		parent_id: 1
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

	msg = "MongoDB indices initialized"
	log_event msg


#####################################################
# Checks
#####################################################

#####################################################
_check_environment_variables = () ->
	msg = "Checking enviromnent variables"
	log_event msg

	url = process.env.MAIL_URL
	if url
		msg = "-- MAIL_URL is set."
		log_event msg
	else
		msg = "-- MAIL_URL not set. Mail notifications are disabled!"
		log_event msg, event_general, event_warn


	token = process.env.DROP_BOX_ACCESS_TOKEN
	if token
		msg = "-- DROP_BOX_ACCESS_TOKEN is set."
		log_event msg
	else
		msg = "-- DROP_BOX_ACCESS_TOKEN not set. Saving files is disabled!"
		log_event msg, event_general, event_warn

	msg = "Environment variables checked"
	log_event msg


#####################################################
# Permissions
#####################################################

#####################################################
_initialize_permissions = () ->
	log_event "Inserting default permissions"

	asset_path = "db/defaultcollections/permissions.json"
	asset_pobj = Meteor.settings.default_permissions_asset_path

	if asset_pobj
		assetp = asset_pobj.toString()
		if not assetp == ""
			asset_path = assetp

	perms_txt = Assets.getText(asset_path)
	perms = JSON.parse(perms_txt)

	for perm, i in perms
		_insert_permission_safe(perm)


#####################################################
# Helper functions to fill in default permissions
#####################################################

#####################################################
_find_permission_by_effectors = (p) ->
	filter =
		role: p.role
		field: p.field
		collection_name: p.collection_name
	Permissions.find(filter)


#####################################################
_insert_permission_unsafe = (p) ->
	id = Permissions.insert p

	if not id
		throw new Meteor.Error 'Could not insert permission to db : ' + p

	return id


#####################################################
_insert_permission_safe = (p) ->
	existing_permission = _find_permission_by_effectors(p)

	if existing_permission.count() == 0
		_insert_permission_unsafe(p)
	else
		#msg = "Permission already exists: " + JSON.stringify(p)
		#log_event msg, event_db, event_info


#####################################################
# Database testing
#####################################################

#####################################################
_add_admin = (email, password) ->
	log_event "Adding admin"
	user = Accounts.findUserByEmail(email)

	if not user
		user =
			email: "admin@mooqita.org",
			password: password,

		user = Accounts.createUser(user)
		Roles.setUserRoles user, ["admin", "db_admin", "editor", "challenge_designer"]
		user = Accounts.findUserByEmail(email)

	filter =
		owner_id: user._id

	profile = Profiles.findOne filter

	if profile
		log_event "-- admin already exists"
		return profile._id

	profile_id = gen_profile user, "learner"
	msg = "admin added " + user.email + " " + profile_id
	log_event msg, event_testing, event_info
	return profile_id


####################################################
_initialize_database = () ->
	console.log "####################################################"
	console.log "##               adding test data                 ##"
	console.log "####################################################"


	title = "The test challenge"
	filter =
		title: title
	challenge = Challenges.findOne filter

	if not challenge
		challenge_id = _test_challenge title
		challenge = Challenges.findOne challenge_id

	learners = []
	for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
		mail = String(i) + "@uni.edu"
		profile_id = _test_user_creation mail, "learner"
		profile = Profiles.findOne profile_id
		user = Meteor.users.findOne profile.owner_id
		learners.push user

	solutions = []
	for s in learners
		solution_id = _test_solution challenge, s
		solution = Solutions.findOne solution_id
		solutions.push solution

	for i in [1..challenge.num_reviews]
		reviews = []
		for s in learners
			review_id = _test_review challenge, null, s
			review = Reviews.findOne review_id
			reviews.push review

	for solution in solutions
		filter =
			solution_id: solution._id
		reviews = Reviews.find(filter).fetch()
		user = Meteor.users.findOne solution.owner_id

		for review in reviews
			_test_feedback solution, review, user

	console.log "####################################################"
	console.log "##                test data added                 ##"
	console.log "####################################################"

	# TODO: test reviews when there is a solution like for tutors

#####################################################
_test_user_creation = (mail, occupation) ->
	user = Accounts.findUserByEmail(mail)

	if not user
		user =
			email: mail,
			password: "none",

		user_id = Accounts.createUser(user)
		user = Meteor.users.findOne user_id
		console.log "Test user creation: " + user.emails[0].address

	filter =
		owner_id: user._id
	profile = Profiles.findOne filter

	if profile
		return profile._id

	profile_id = gen_profile user
	modify_field_unprotected Profiles, profile_id, "avatar", faker.image.avatar()
	modify_field_unprotected Profiles, profile_id, "given_name", faker.name.firstName()
	modify_field_unprotected Profiles, profile_id, "family_name", faker.name.lastName()
	modify_field_unprotected Profiles, profile_id, "middle_name", faker.name.firstName()
	modify_field_unprotected Profiles, profile_id, "city", faker.address.city()
	modify_field_unprotected Profiles, profile_id, "country", faker.address.country()
	modify_field_unprotected Profiles, profile_id, "state", faker.address.state()
	modify_field_unprotected Profiles, profile_id, "hours_per_week", Math.round(Random.fraction() * 40)
	modify_field_unprotected Profiles, profile_id, "job_locale", Random.choice ["remote", "local"]
	modify_field_unprotected Profiles, profile_id, "job_type", Random.choice ["free", "full"]
	modify_field_unprotected Profiles, profile_id, "occupation", occupation
	modify_field_unprotected Profiles, profile_id, "resume", faker.lorem.paragraphs 2
	modify_field_unprotected Profiles, profile_id, "job_interested", true
	modify_field_unprotected Profiles, profile_id, "test_object", true

	return profile_id


#####################################################
_test_challenge = (title) ->
	user = Accounts.findUserByEmail("designer@mooqita.org")
	if not user
		_test_user_creation "designer@mooqita.org", "organization"
		user = Accounts.findUserByEmail("designer@mooqita.org")
		Roles.setUserRoles user, ["admin", "editor", "challenge_designer"]

	challenge_id = gen_challenge user

	modify_field_unprotected Challenges, challenge_id, "title", title
	modify_field_unprotected Challenges, challenge_id, "content", faker.lorem.paragraphs(3)
	modify_field_unprotected Challenges, challenge_id, "test_object", true

	#TODO: add test for material

	challenge = Challenges.findOne challenge_id
	challenge_id = finish_challenge challenge, user
	return challenge_id


#####################################################
_test_solution = (challenge, user) ->
	filter =
		challenge_id: challenge._id
		owner_id: user._id

	solution = Solutions.findOne filter
	if solution
		return solution._id

	solution_id = gen_solution challenge, user
	modify_field_unprotected Solutions, solution_id, "content", faker.lorem.paragraphs(3)
	modify_field_unprotected Solutions, solution_id, "test_object", true

	solution = Solutions.findOne solution_id
	solution_id = finish_solution solution, user

	solution = Solutions.findOne solution_id
	solution_id = reopen_solution solution, user

	solution = Solutions.findOne solution_id
	solution_id = finish_solution solution, user

	#TODO: add reopen fail test

	return solution_id


#####################################################
_test_review = (challenge, solution, user) ->
	try
		res = assign_review challenge, solution, user
	catch e
		if e.error == "no-review"
			return
		throw e

	modify_field_unprotected Reviews, res.review_id, "content", faker.lorem.paragraphs(3)
	modify_field_unprotected Reviews, res.review_id, "rating", Random.choice [1,2,3,4,5]
	modify_field_unprotected Reviews, res.review_id, "test_object", true

	review = Reviews.findOne res.review_id
	review_id = finish_review review, user

	review = Reviews.findOne res.review_id
	review_id = reopen_review review, user

	review = Reviews.findOne res.review_id
	review_id = finish_review review, user

	#TODO: add reopen fail test

	return review_id


#####################################################
_test_feedback = (solution, review, user) ->
	feedback_id = gen_feedback solution, review, user

	feedback = Feedback.findOne feedback_id
	if feedback.published == true
		return

	modify_field_unprotected Feedback, feedback_id, "content", faker.lorem.paragraphs(3)
	modify_field_unprotected Feedback, feedback_id, "rating", Random.choice [1,2,3,4,5]
	modify_field_unprotected Feedback, feedback_id, "test_object", true

	feedback = Feedback.findOne feedback_id

	feedback_id = finish_feedback feedback, user
	feedback_id = reopen_feedback feedback, user
	feedback_id = finish_feedback feedback, user

	#TODO: add reopen test
	#TODO: add reopen fail test
	#TODO: add repair fail test

	return feedback_id


#####################################################
# start up
#####################################################
Meteor.startup () ->
	try
		_handle_startup_setting()
	catch e
		console.log e
		msg = String(e)
		log_event msg, event_testing, event_err
