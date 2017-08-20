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

	profile_id = gen_profile user, "student"

	msg = "admin added " + user.email + " " + profile_id
	loig_event msg, event_testing, event_info
	return profile_id


####################################################
@run_db_tests = () ->
	title = "The test challenge"
	filter =
		title: title
	challenge = Challenges.findOne filter

	if not challenge
		challenge_id = test_challenge title
		challenge = Challenges.findOne challenge_id

	students = []
	for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
		mail = String(i) + "uni@edu"
		profile_id = test_user_creation mail, "student"
		profile = Profiles.findOne profile_id
		user = Meteor.users.findOne profile.owner_id
		students.push user

	solutions = []
	for s in students
		solution_id = test_solution challenge, s
		solution = Solutions.findOne solution_id
		solutions.push solution

	for i in [1..challenge.num_reviews]
		reviews = []
		for s in students
			review_id = test_review challenge, null, s
			review = Reviews.findOne review_id
			reviews.push review

	for solution in solutions
		filter =
			solution_id: solution._id
		reviews = Reviews.find(filter).fetch()
		user = Meteor.users.findOne solution.owner_id

		for review in reviews
			test_feedback solution, review, user

	console.log "####################################################"
	console.log "##                test data added                 ##"
	console.log "####################################################"

	# TODO: test reviews when there is a solution like for tutors

#####################################################
@test_user_creation = (mail, occupation) ->
	user = Accounts.findUserByEmail(mail)

	if !user
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
	modify_field_unprotected Profiles, profile_id, "test_object", true

	return profile_id


#####################################################
@test_challenge = (title) ->
	user = Accounts.findUserByEmail("designer@mooqita.org")
	if not user
		test_user_creation "designer@mooqita.org", "company"
		user = Accounts.findUserByEmail("designer@mooqita.org")

	challenge_id = gen_challenge user

	modify_field_unprotected Challenges, challenge_id, "title", title
	modify_field_unprotected Challenges, challenge_id, "content", faker.lorem.paragraphs(3)

	#TODO: add test for material

	challenge = Challenges.findOne challenge_id
	challenge_id = finish_challenge challenge, user
	return challenge_id


#####################################################
@test_solution = (challenge, user) ->
	filter =
		challenge_id: challenge._id
		owner_id: user._id

	solution = Solutions.findOne filter
	if solution
		return solution._id

	solution_id = gen_solution challenge, user
	modify_field_unprotected Solutions, solution_id, "content", faker.lorem.paragraphs(3)

	solution = Solutions.findOne solution_id
	solution_id = finish_solution solution, user

	solution = Solutions.findOne solution_id
	solution_id = reopen_solution solution, user

	solution = Solutions.findOne solution_id
	solution_id = finish_solution solution, user

	#TODO: add reopen fail test

	return solution_id


#####################################################
@test_review = (challenge, solution, user) ->
	res = assign_review challenge, solution, user

	modify_field_unprotected Reviews, res.review_id, "content", faker.lorem.paragraphs(3)
	modify_field_unprotected Reviews, res.review_id, "rating", Random.choice [1,2,3,4,5]

	review = Reviews.findOne res.review_id
	review_id = finish_review review, user

	review = Reviews.findOne res.review_id
	review_id = reopen_review review, user

	review = Reviews.findOne res.review_id
	review_id = finish_review review, user

	#TODO: add reopen fail test

	return review_id

#####################################################
@test_feedback = (solution, review, user) ->
	feedback_id = gen_feedback solution, review, user

	modify_field_unprotected Feedback, feedback_id, "content", faker.lorem.paragraphs(3)
	modify_field_unprotected Feedback, feedback_id, "rating", Random.choice [1,2,3,4,5]

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
		add_admin()
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

Meteor.methods
	db_test: () ->
		run_db_tests()
		#TODO: change all by object functions to by _id functions

