###############################################################################
#
# Created by Markus on 26/10/2015.
#
###############################################################################

###############################################################################
_handle_startup_setting = () ->
	# make sure all indices are created
	_check_environment_variables()
	_initialize_variables()
	_initialize_indices()

	# The rest only works with a settings file and on localhost.
	# For security reasons we do not create default admin access.
	if not Meteor.settings
		return

	if get_environment() != "local"
		return

	# add an admin if on localhost
	if Meteor.settings.admin
		param = Meteor.settings.admin
		_add_admin param.email, param.password

	# set default permissions if necessary
	if Meteor.settings.init_default_permissions && (Meteor.settings.init_default_permissions == true)
		initialize_permissions()

	# add test data
	if Meteor.settings.init_test_data
		run_database_test_bed()


###############################################################################
_add_admin = (email, password) ->
	log_event "Adding admin"
	user = Accounts.findUserByEmail(email)

	if not user
		user =
			email: "admin@mooqita.org"
			password: password

		user = Accounts.createUser(user)
		user = Accounts.findUserByEmail(email)
		Roles.addUsersToRoles(user, "admin")

	profile = get_profile user._id

	if profile
		log_event "-- admin already exists"
		return profile._id

	profile_id = gen_profile user
	msg = "admin added " + user.email + " " + profile_id
	log_event msg, event_testing, event_info
	return profile_id


###############################################################################
# Checks
###############################################################################

###############################################################################
_check_environment_variables = () ->
	msg = "Checking enviromnent variables"
	log_event msg

	variable = process.env.LINKED_IN_SECRET
	if variable
		msg = "-- LINKED_IN_SECRET is set."
		log_event msg
	else
		msg = "-- LINKED_IN_SECRET not set. LinkedIn integration disabled!"
		log_event msg, event_general, event_warn

	variable = process.env.LINKED_IN_CLIENT
	if variable
		msg = "-- LINKED_IN_CLIENT is set."
		log_event msg
	else
		msg = "-- LINKED_IN_CLIENT not set. LinkedIn integration disabled!"
		log_event msg, event_general, event_warn

	variable = process.env.OAUTH_ENCRYPT_SECRET
	if variable
		msg = "-- OAUTH_ENCRYPT_SECRET is set."
		log_event msg
	else
		msg = "-- OAUTH_ENCRYPT_SECRET not set. Service secrets will not be encrypted in database!"
		log_event msg, event_general, event_warn

	url = process.env.MAIL_URL
	if url
		msg = "-- MAIL_URL is set."
		log_event msg
	else
		msg = "-- MAIL_URL not set. Mail notifications disabled!"
		log_event msg, event_general, event_warn

	token = process.env.DROP_BOX_ACCESS_TOKEN
	if token
		msg = "-- DROP_BOX_ACCESS_TOKEN is set."
		log_event msg
	else
		msg = "-- DROP_BOX_ACCESS_TOKEN not set. Saving files disabled!"
		log_event msg, event_general, event_warn

	token = process.env.MONGO_URL
	if token
		msg = "-- MONGO_URL is set."
		log_event msg

	msg = "Environment variables checked"
	log_event msg


###############################################################################
# Load variables
###############################################################################

###############################################################################
_initialize_variables = () ->
	check process.env.OAUTH_ENCRYPT_SECRET, String
	check process.env.LINKED_IN_CLIENT, String  # See table below for correct property name!
	check process.env.LINKED_IN_SECRET, String

	Accounts.config
		oauthSecretKey: process.env.OAUTH_ENCRYPT_SECRET, String

		service =
			service: "linkedin"

		prop =
			$set:
				loginStyle: "popup"
				clientId: process.env.LINKED_IN_CLIENT  # See table below for correct property name!
				secret: process.env.LINKED_IN_SECRET

	ServiceConfiguration.configurations.upsert(service, prop)

###############################################################################
# Prepare indices
###############################################################################

###############################################################################
_initialize_indices = ()->
	msg = "Validating MongoDB indices"
	log_event msg

	index =
		c: 1 # collection_name
		i: 1 # item_id
		r: 1 # role
	Admissions._ensureIndex index

	index =
		c: 1 # collection_name
		u: 1 # user_id
		r: 1 # role
	Admissions._ensureIndex index

	index =
		c: 1 # collection_name
		r: 1 # role
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
	Messages._ensureIndex index
	Feedback._ensureIndex index
	Reviews._ensureIndex index
	Posts._ensureIndex index

	index =
		c: 1
		i: 1
		f: 1
	Documents._ensureIndex index

	index =
		t: "text"
	Documents._ensureIndex index

	index =
		locked_by: 1
		locked_at: 1
		attempts: 1
		task: 1
	NLPTasks._ensureIndex index

	index =
		created: 1
	NLPTasks._ensureIndex index, {expireAfterSeconds: 3600}

	index =
		c: "text"
	Matches._ensureIndex index

	index =
		ca: 1
		cb: 1
		fa: 1
		fb: 1
		ids: 1
	Matches._ensureIndex index

	index =
		ids: 1
	Matches._ensureIndex index

	msg = "MongoDB indices initialized"
	log_event msg


###############################################################################
# start up
###############################################################################
Meteor.startup () ->
	try
		_handle_startup_setting()
	catch e
		console.log e
		msg = String(e)
		log_event msg, event_testing, event_err
