#####################################################
@run_tests = () ->
	challenge_id = test_challenge()
	challenge = Challenges.findOne challenge_id

	students = []
	for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
		mail = String(i) + "uni@edu"
		profile_id = test_user_creation mail, "student"
		user = Meteor.users.findOne profile_id
		students.push user

	solutions = []
	for s in students
		solution_id = test_solution challenge, s
		solution = Solutions.findOne solution_id
		solutions.push solution

	reviews = []
	for s in students
		review_id = test_review challenge, null, s
		review = Reviews.findOne review_id
		reviews.push review

	for i in challenge.num_reviews
		for review in reviews
			solution = Solutions.findOne review.solution_id
			user = Meteor.users.findOne solution.owner_id
			test_feedback solution, review, user

	# TODO: test reviews when there is a solution like for tutors

#####################################################
@test_user_creation = (mail, occupation) ->
	user = Accounts.findUserByEmail(mail)

	if !user
		user =
			email: mail,
			password: "none",
			test_object: true

		user = Accounts.createUser(user)
		console.log "Test user creation: " + user.email

	filter =
		owner_id: user._id
	profile = Profiles.findOne filter

	if profile
		return profile._id

	profile_id = gen_profile user._id
	modify_field_unprotected "Profiles", profile_id, "avatar", faker.image.avatar()
	modify_field_unprotected "Profiles", profile_id, "give_name", faker.name.firstName()
	modify_field_unprotected "Profiles", profile_id, "family_name", faker.name.lastName()
	modify_field_unprotected "Profiles", profile_id, "middle_name", faker.name.firstName()
	modify_field_unprotected "Profiles", profile_id, "city", faker.address.city()
	modify_field_unprotected "Profiles", profile_id, "country", faker.address.country()
	modify_field_unprotected "Profiles", profile_id, "state", faker.address.state()
	modify_field_unprotected "Profiles", profile_id, "hours_per_week", int(Random.fraction() * 40)
	modify_field_unprotected "Profiles", profile_id, "job_locale", Random.choice ["remote", "local"]
	modify_field_unprotected "Profiles", profile_id, "job_type", Random.choice ["free", "full"]
	modify_field_unprotected "Profiles", profile_id, "state", occupation
	modify_field_unprotected "Profiles", profile_id, "resume", faker.lorem.paragraphs 2

	return profile_id


#####################################################
@test_challenge = () ->
	user = Accounts.findUserByEmail("designer@mooqita.org")
	if not user
		test_user_creation "designer@mooqita.org", "company"
		user = Accounts.findUserByEmail("designer@mooqita.org")

	challenge_id = gen_challenge user

	modify_field_unprotected Challenges, challenge_id, "title", faker.lorem.sentence()
	modify_field_unprotected Challenges, challenge_id, "content", faker.lorem.paragraphs(3)

	#TODO: add test for material

	challenge = Challenges.findOne challenge_id
	challenge_id = finish_challenge challenge, user
	return challenge_id


#####################################################
@test_solution = (challenge, user) ->
	solution_id = gen_solution challenge, user
	modify_field_unprotected Solutions, solution_id, "content", faker.lorem.paragraphs(3)

	solution = Solutions.findOne solution_id
	solution_id = finish_solution solution, user
	solution_id = reopen_solution solution, user
	solution_id = finish_solution solution, user

	#TODO: add reopen fail test

	return solution_id


#####################################################
@test_review = (challenge, solution, user) ->
	review_id = find_review challenge, solution, user

	modify_field_unprotected Reviews, review_id, "content", faker.lorem.paragraphs(3)
	modify_field_unprotected Reviews, review_id, "rating", Random.choice [1,2,3,4,5]

	review = Reviews.findOne review_id

	review_id = finish_review review, user
	review_id = reopen_review review, user
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
	feedback_id = repair_feedback feedback, user
	feedback_id = finish_feedback feedback, user

	#TODO: add reopen test
	#TODO: add reopen fail test
	#TODO: add repair fail test

	return feedback_id
