#####################################################
#
# Created by Markus on 26/10/2017.
#
#####################################################

#####################################################
_designer_email = "designer@mooqita.org"
_learner_email = "@uni.edu"

#####################################################
_challenge_title = "The test challenge"

#####################################################
_run_test_bed = () ->
	console.log "####################################################"
	console.log "##                running test bed                ##"
	console.log "####################################################"

	designer = _test_get_designer _designer_email
	learners = _test_get_learners _learner_email
	challenge = _test_challenge _challenge_title, designer
	solutions = _test_solutions challenge, learners
	reviews = _test_reviews challenge, learners
	feedback = _test_feedbacks solutions

	console.log "####################################################"
	console.log "##               test run finished                ##"
	console.log "####################################################"

	# TODO: test reviews when there is a solution like for tutors


#####################################################
_test_get_designer = (email) ->
	user = Accounts.findUserByEmail(email)
	if not user
		_test_user_creation email, "organization"
		user = Accounts.findUserByEmail email

	return user


#####################################################
_test_get_learners = (email_template) ->
	learners = []
	for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
		mail = String(i) + email_template
		profile_id = _test_user_creation mail, "learner"
		user = get_document_owner Profiles, profile_id
		learners.push user

	return learners

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

	profile = get_document user, OWNER, Profiles

	if profile
		return profile._id

	profile_id = test_gen_profile user
	set_field Profiles, profile_id, "avatar", faker.image.avatar()
	set_field Profiles, profile_id, "given_name", faker.name.firstName()
	set_field Profiles, profile_id, "family_name", faker.name.lastName()
	set_field Profiles, profile_id, "middle_name", faker.name.firstName()
	set_field Profiles, profile_id, "city", faker.address.city()
	set_field Profiles, profile_id, "country", faker.address.country()
	set_field Profiles, profile_id, "state", faker.address.state()
	set_field Profiles, profile_id, "hours_per_week", Math.round(Random.fraction() * 40)
	set_field Profiles, profile_id, "job_locale", Random.choice ["remote", "local"]
	set_field Profiles, profile_id, "job_type", Random.choice ["free", "full"]
	set_field Profiles, profile_id, "occupation", occupation
	set_field Profiles, profile_id, "resume", faker.lorem.paragraphs 2
	set_field Profiles, profile_id, "job_interested", true
	set_field Profiles, profile_id, "test_object", true

	return profile_id


#####################################################
_test_challenge = (title, designer) ->
	filter = {title: title}
	challenge = get_document designer, OWNER, Challenges, filter

	challenge_id = test_gen_challenge designer

	set_field Challenges, challenge_id, "title", title
	set_field Challenges, challenge_id, "content", faker.lorem.paragraphs(3)
	set_field Challenges, challenge_id, "test_object", true

	#TODO: add test for material

	challenge = Challenges.findOne challenge_id
	challenge_id = finish_challenge challenge, user
	challenge = get_document designer, OWNER, Challenges, {_id:challenge_id}

	return challenge


#####################################################
_test_solutions = (challenge, learners) ->
	solutions = []
	for s in learners
		solution = _test_solution challenge, s
		solution = Solutions.findOne solution_id
		solutions.push solution

	return solutions


#####################################################
_test_solution = (challenge, learner) ->
	solution = get_document learner._id, OWNER, "solutions", {challenge_id: challenge._id}
	if solution
		return solution._id

	solution_id = test_gen_solution challenge, learner
	set_field Solutions, solution_id, "content", faker.lorem.paragraphs(3)
	set_field Solutions, solution_id, "test_object", true

	solution = get_document learner, OWNER, Solutions {_id: solution_id}
	solution_id = test_finish_solution solution, learner

	solution = get_document learner, OWNER, Solutions {_id: solution_id}
	solution_id = test_reopen_solution solution, learner

	solution = get_document learner, OWNER, Solutions {_id: solution_id}
	solution_id = test_finish_solution solution, learner

	#TODO: add reopen fail test

	return solution_id

#####################################################
_test_reviews = (challenge, learners) ->
	reviews = []
	for i in [1..challenge.num_reviews]
		for learner in learners
			review = _test_review challenge, learner
			reviews.push review

	return reviews


#####################################################
_test_review = (challenge, learner) ->
	try
		res = test_assign_review challenge, null, learner
	catch e
		if e.error == "no-review"
			return
		throw e

	set_field Reviews, res.review_id, "content", faker.lorem.paragraphs 3
	set_field Reviews, res.review_id, "rating", Random.choice [1, 2, 3, 4, 5]
	set_field Reviews, res.review_id, "test_object", true

	review = get_document learner, OWNER, Reviews {_id: res.review_id}
	review_id = test_finish_review review, learner

	review = get_document learner, OWNER, Reviews {_id: res.review_id}
	review_id = test_reopen_review review, learner

	review = get_document learner, OWNER, Reviews {_id: res.review_id}
	review_id = test_finish_review review, learner

	#TODO: add reopen fail test

	return review_id


#####################################################
_test_feedbacks = (solutions) ->
	for solution in solutions
		learner = get_document_owner Solutions, solution._id

		filter = {solution_id: solution._id}
		reviews = get_documents learner RECIPIENT Reviews, filter

		for review in reviews.fetch()
			_test_feedback solution, review, learner


#####################################################
_test_feedback = (solution, review, learner) ->
	feedback_id = test_gen_feedback solution, review, learner

	feedback = get_my_document learner, OWNER, Feedback, {_id:feedback_id}
	if feedback.published == true
		return

	set_field Feedback, feedback_id, "content", faker.lorem.paragraphs(3)
	set_field Feedback, feedback_id, "rating", Random.choice [1, 2, 3, 4, 5]
	set_field Feedback, feedback_id, "test_object", true

	feedback = get_document learner, OWNER, Feedback, {_id:feedback_id}

	test_finish_feedback feedback, learner
	test_reopen_feedback feedback, learner
	test_finish_feedback feedback, learner

	feedback = get_document learner, OWNER, Feedback, {_id:feedback_id}

	return feedback_id

