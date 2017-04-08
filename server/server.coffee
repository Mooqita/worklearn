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
_wipe_user = (user_id) ->
	filter =
		owner_id: user_id

	Responses.remove filter
	Meteor.users.remove user_id

	console.log "User wiped: " + user_id


#####################################################
@generate_users = (n, callback) ->
	user_ids = []

	for i in [1..n]
		user = Accounts.findUserByEmail(i + '@uni.edu')

		if user
			_wipe_user user._id

		user =
			email: i + '@uni.edu',
			password: 'none',

		res = Accounts.createUser user
		profile_id = gen_profile res

		modify_field_unprotected "Responses", profile_id, "avatar", faker.image.avatar()
		modify_field_unprotected "Responses", profile_id, "given_name", faker.name.firstName()
		modify_field_unprotected "Responses", profile_id, "family_name", faker.name.lastName()
		modify_field_unprotected "Responses", profile_id, "resume", faker.lorem.paragraphs(2)

		console.log user.email
		user_ids.push user._id

	if callback
		callback user_ids

	return user_ids


#####################################################
@generate_challenges = (user_indices, callback) ->
	secret = Secrets.findOne()
	config =
		consumerKey: secret.upwork.oauth.consumerKey
		consumerSecret: secret.upwork.oauth.consumerSecret

	UpworkApi = require('upwork-api')
	Search = require('upwork-api/lib/routers/jobs/search.js').Search

	api = new UpworkApi(config)
	jobs = new Search(api)
	params =
		q: "python"
		budget: "5000-50000"
		job_type: 'fixed'
	accessToken = secret.upwork.oauth.accessToken
	accessTokenSecret = secret.upwork.oauth.accessSecret

	api.setAccessToken accessToken, accessTokenSecret, () ->

	remote = (error, data) ->
		user  = Accounts.findUserByEmail '1@uni.edu'
		challenge_ids = []

		if error
			console.log error

			challenge_id = gen_challenge user._id
			modify_field_unprotected "Responses", challenge_id,
					"visible_to", "anonymous"
			modify_field_unprotected "Responses", challenge_id,
					"content", faker.lorem.paragraphs(2)
			modify_field_unprotected "Responses", challenge_id,
					"title", faker.lorem.sentence()
			modify_field_unprotected "Responses", challenge_id,
					"name", "Random challenge: " + faker.lorem.sentence()

			challenge_ids.push challenge_id
			callback challenge_ids, user_indices
		else
			for d in data.jobs
				if Tasks.findOne d.id
					continue

				content = d.snippet.split('\n').join('<br>')
				title = d.title
				name = "UpWork Challenge: " + d.title

				challenge_id = gen_challenge user._id
				modify_field_unprotected "Responses", challenge_id, "visible_to", "anonymous"
				modify_field_unprotected "Responses", challenge_id, "content", content
				modify_field_unprotected "Responses", challenge_id, "title", title
				modify_field_unprotected "Responses", challenge_id, "name", name
				challenge_ids.push challenge_id

			callback challenge_ids, user_indices

	bound = Meteor.bindEnvironment remote
	res = jobs.find params, bound

	console.log 'Challenge added.'
	return res

#####################################################
@generate_solutions = (challenge_id, user_indices) ->
	for u_index in user_indices
		challenge = Responses.findOne challenge_id

		user = Accounts.findUserByEmail u_index+'@uni.edu'
		if not user
			console.log 'user not found: ' + u_index + '@uni.edu'
			return

		content = faker.lorem.paragraphs(3)
		solution_id = gen_solution challenge, user._id
		solution = Responses.findOne solution_id

		modify_field_unprotected "Responses", solution_id, "visible_to", "anonymous"
		modify_field_unprotected "Responses", solution_id, "content", content
		request_review solution, user._id

		console.log 'solution added: ' + solution_id


#####################################################
@generate_reviews = (challenge_id, user_indices) ->
	for u_index in user_indices
		user = Accounts.findUserByEmail u_index+'@uni.edu'

		if not user
			console.log 'user not found: '+u_index+'@uni.edu'
			return

		chl_sol = find_solution_to_review user._id
		rev_fed = gen_review chl_sol.challenge, chl_sol.solution, user._id

		r_content = faker.lorem.paragraphs(2)
		rating = Math.round(Math.random()*4, 0) + 1
		modify_field_unprotected "Responses", rev_fed.review_id, "content", r_content
		modify_field_unprotected "Responses", rev_fed.review_id, "rating", rating

		review = Responses.findOne rev_fed.review_id
		finish_review review, user._id

		console.log 'review added: ' + rev_fed.review_id

		f_content = faker.lorem.paragraphs(1)
		modify_field_unprotected "Responses", rev_fed.feedback_id, "content", f_content
		modify_field_unprotected "Responses", rev_fed.feedback_id, "visible_to", "anonymous"

		console.log 'feedback added: ' + rev_fed.feedback_id

	return true


#####################################################
@simulate_users = (challenge_ids, user_indices) ->
	for c_id in challenge_ids
		generate_solutions c_id, user_indices
		generate_reviews c_id, user_indices

	Secrets.insert {wipe:false}


#####################################################
@initialize_database = () ->
	if Secrets.findOne {wipe:false}
		return

	###################################################
	if not Accounts.findUserByEmail('admin@worklearn.com')
		add_admin()

	###################################################
	generate_users(10)
	generate_challenges([1..10], simulate_users)

	return true

#####################################################
# start up
#####################################################
Meteor.startup () ->
	try
		initialize_database()
	catch e
		console.log e

