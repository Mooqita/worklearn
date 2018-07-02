#####################################################
#
# Created by Markus on 26/10/2017.
#
#####################################################

#####################################################
_designer_email = "designer@mooqita.org"
_learner_email = "@uni.edu"

#####################################################
_organization_title_base = ["Organization "]

#####################################################
_challenge_title = "The test challenge"
_challenge_title_base = ["Challenge "]

#####################################################
@run_database_test_bed = () ->
	console.log "####################################################"
	console.log "##                running test bed                ##"
	console.log "####################################################"

	designer = _test_get_designer _designer_email
	learners = _test_get_learners _learner_email
	challenge = _test_challenge _challenge_title, designer
	solutions = _test_solutions challenge, learners

	_test_reviews challenge, learners
	_test_feedbacks solutions

	# Add more challenges and jobs for an nlp test
	organizations = _test_organizations designer
	_test_jobs(designer, organizations)

	console.log "####################################################"
	console.log "##               test run finished                ##"
	console.log "####################################################"

	# TODO: test reviews when there is a solution like for tutors


#####################################################
_test_get_designer = (email) ->
	user = Accounts.findUserByEmail(email)
	if user
		return user

	_test_user_creation email, "organization"
	user = Accounts.findUserByEmail email
	return user


#####################################################
_test_get_learners = (email_template) ->
	learners = []
	for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
		mail = String(i) + email_template
		profile_id = _test_user_creation mail, "learner"
		user_id = get_document_owner Profiles, profile_id
		user = Meteor.users.findOne(user_id)
		learners.push user

	return learners


#####################################################
_test_user_creation = (mail) ->
	user = Accounts.findUserByEmail(mail)

	if user
		profile = get_document user, "owner", Profiles
		return profile._id

	user =
		email: mail
		password: "none"

	user_id = Accounts.createUser user
	user = Meteor.users.findOne user_id
	console.log "Test user creation: " + get_user_mail user

	profile = get_profile user
	profile_id = profile._id

	big_five = randomize_big_five(big_five_15)

	modify_field_unprotected Profiles, profile_id, "avatar", faker.image.avatar()
	modify_field_unprotected Profiles, profile_id, "given_name", faker.name.firstName()
	modify_field_unprotected Profiles, profile_id, "family_name", faker.name.lastName()
	modify_field_unprotected Profiles, profile_id, "middle_name", faker.name.firstName()

	modify_field_unprotected Profiles, profile_id, "city", faker.address.city()
	modify_field_unprotected Profiles, profile_id, "country", faker.address.country()
	modify_field_unprotected Profiles, profile_id, "state", faker.address.state()

	modify_field_unprotected Profiles, profile_id, "job_interested", true
	modify_field_unprotected Profiles, profile_id, "job_type", Random.choice ["free", "full"]
	modify_field_unprotected Profiles, profile_id, "job_locale", Random.choice ["remote", "local"]
	modify_field_unprotected Profiles, profile_id, "hours_per_week", Math.round(Random.fraction() * 40)

	modify_field_unprotected Profiles, profile_id, "resume", faker.lorem.paragraphs 2
	modify_field_unprotected Profiles, profile_id, "big_five", big_five

	modify_field_unprotected Profiles, profile_id, "test_object", true

	return profile_id


#####################################################
_test_organizations = (designer) ->
	organizations = []
	for i in [1..10]
		name = _organization_title_base + i
		organization = _test_organization(name, designer)
		organizations.push(organization)

	return organizations


#####################################################
_test_organization = (name, designer) ->
	organization = Organizations.findOne({name:name})
	if organization
		return organization

	organization_id = gen_organization(null, designer)

	content = get_profile_name(get_profile(designer)) + ": "
	content += faker.lorem.paragraphs(3)

	modify_field_unprotected Organizations, organization_id, "name", name
	modify_field_unprotected Organizations, organization_id, "description", content
	modify_field_unprotected Organizations, organization_id, "avatar", faker.image.avatar()
	modify_field_unprotected Organizations, organization_id, "test_object", true

	organization = get_document designer, OWNER, Organizations, {_id:organization_id}
	return organization


#####################################################
_test_jobs = (designer, organizations) ->
	jobs = []

	for org in organizations
		job = _test_job(designer, org)
		jobs.push(job)

	return jobs


#####################################################
_test_job = (designer, organization) ->
	title = get_profile_name(get_profile(designer)) + " for: " + organization.name

	job = Jobs.findOne({title:title})
	if job
		return job

	job_id = gen_job(null, designer)

	content = title
	content += faker.lorem.paragraphs(3)

	role = Random.choice ["design", "ops", "sales", "other", "marketing", "dev"]

	challenges = _test_challenges(designer, 3)
	challenge_ids = (c._id for c in challenges)

	modify_field_unprotected Jobs, job_id, "title", title
	modify_field_unprotected Jobs, job_id, "description", content
	modify_field_unprotected Jobs, job_id, "organization_id", organization._id

	modify_field_unprotected Jobs, job_id, "role", role
	modify_field_unprotected Jobs, job_id, "team", Random.choice [1,0]
	modify_field_unprotected Jobs, job_id, "idea", Random.choice [1,0]
	modify_field_unprotected Jobs, job_id, "social", Random.choice [1,0]
	modify_field_unprotected Jobs, job_id, "process", Random.choice [1,0]
	modify_field_unprotected Jobs, job_id, "strategic", Random.choice [1,0]
	modify_field_unprotected Jobs, job_id, "contributor", Random.choice [1,0]

	modify_field_unprotected Jobs, job_id, "challenge_ids", challenge_ids
	modify_field_unprotected Jobs, job_id, "test_object", true

	job = get_document designer, OWNER, Jobs, {_id:job_id}
	return job


#####################################################
_test_challenges = (designer, count) ->
	challenges = []
	for i in [1..count]
		title = faker.lorem.sentence()
		challenges.push(_test_challenge(title, designer))

	return challenges


#####################################################
_test_challenge = (title, designer) ->
	filter = {title: title}
	challenge = get_document designer, OWNER, Challenges, filter

	if challenge
		return challenge

	challenge_id = gen_challenge designer

	content = get_profile_name(designer) + ": "
	content += faker.lorem.paragraphs(3)

	modify_field_unprotected Challenges, challenge_id, "title", title
	modify_field_unprotected Challenges, challenge_id, "content", content
	modify_field_unprotected Challenges, challenge_id, "test_object", true
	modify_field_unprotected Challenges, challenge_id, "discoverable", true

	#TODO: add test for material

	challenge = Challenges.findOne challenge_id
	challenge_id = finish_challenge challenge, designer
	challenge = get_document designer, OWNER, Challenges, {_id:challenge_id}

	return challenge


#####################################################
_test_solutions = (challenge, learners) ->
	solutions = []
	for s in learners
		solution = _test_solution challenge, s
		solutions.push solution

	return solutions


#####################################################
_test_solution = (challenge, learner) ->
	solution = get_document learner._id, OWNER, "solutions", {challenge_id: challenge._id}
	if solution
		return solution

	solution_id = gen_solution challenge, learner
	content = get_profile_name(get_profile(learner)) + ": "
	content += faker.lorem.paragraphs(3)

	modify_field_unprotected Solutions, solution_id, "content", content
	modify_field_unprotected Solutions, solution_id, "test_object", true

	solution = get_document learner, OWNER, Solutions, {_id: solution_id}
	solution_id = finish_solution solution, learner

	#TODO: add reopen fail test
	#TODO: add reopen success test

	return solution_id

#####################################################
_test_reviews = (challenge, learners) ->
	reviews = []
	for i in [1..challenge.num_reviews]
		for learner in learners
			filter =
				challenge_id: challenge._id
			review_crs = get_documents learner, OWNER, Reviews, filter

			if review_crs.count() >= challenge.num_reviews
				console.log "review count satisfied."
				continue

			review_id = _test_review challenge, learner
			reviews.push review_id

	return reviews


#####################################################
_test_review = (challenge, learner) ->
	res = assign_review challenge, learner
	recipient = get_document_owner(Solutions, res.solution_id)

	content = get_profile_name(get_profile(learner)) + " for "
	content += get_profile_name(get_profile(recipient)) + ": "
	content += faker.lorem.paragraphs(3)

	modify_field_unprotected Reviews, res.review_id, "content", content
	modify_field_unprotected Reviews, res.review_id, "rating", Random.choice [1, 2, 3, 4, 5]
	modify_field_unprotected Reviews, res.review_id, "test_object", true

	review = get_document learner, OWNER, Reviews, {_id: res.review_id}
	review_id = finish_review review, learner

	#TODO: add reopen fail test
	#TODO: add reopen success test

	return review_id


#####################################################
_test_feedbacks = (solutions) ->
	feedbacks = []

	for solution_id in solutions
		solution = Solutions.findOne(solution_id)
		learner = get_document_owner Solutions, solution_id

		filter = {solution_id: solution_id}
		reviews = get_documents learner, RECIPIENT, Reviews, filter

		for review in reviews.fetch()
			feedback = _test_feedback solution, review, learner
			feedbacks.push feedback

	return feedbacks


#####################################################
_test_feedback = (solution, review, learner) ->
	feedback_id = gen_feedback solution, review, learner

	feedback = Feedback.findOne(feedback_id)
	feedback = get_document learner, OWNER, Feedback, {_id:feedback_id}
	if feedback.published == true
		return

	recipient = get_document_owner(Reviews, feedback.review_id)

	content = get_profile_name(get_profile(learner)) + " for "
	content += get_profile_name(get_profile(recipient)) + ": "
	content += faker.lorem.paragraphs(3)

	modify_field_unprotected Feedback, feedback_id, "content", content
	modify_field_unprotected Feedback, feedback_id, "rating", Random.choice [1, 2, 3, 4, 5]
	modify_field_unprotected Feedback, feedback_id, "test_object", true

	feedback = get_document learner, OWNER, Feedback, {_id:feedback_id}

	finish_feedback feedback, learner
	reopen_feedback feedback, learner
	finish_feedback feedback, learner

	feedback = get_document learner, OWNER, Feedback, {_id:feedback_id}

	return feedback_id

