#####################################################
#
# Created by Markus on 26/10/2015.
#
#####################################################

#####################################################
_reset_user = (user_id) ->
	filter =
		owner_id: user_id

	mod =
		$set:
			requested: 0
			provided: 0

	Profiles.update filter, mod

	filter =
		owner_id: user_id

	Profiles.remove filter
	console.log "User reset: " + user_id


#####################################################
_generate_users = (n, callback) ->
	user_ids = []

	for i in [1..n]
		user = Accounts.findUserByEmail(i + '@uni.edu')

		if user
			_reset_user user._id
			continue

		user =
			email: i + '@uni.edu',
			password: 'none',

		res = Accounts.createUser user
		profile_id = gen_profile res
		name = faker.name.firstName()
		resume = "Resume for " + name + ": " + faker.lorem.paragraphs(2)

		modify_field_unprotected Profiles, profile_id, "avatar", faker.image.avatar()
		modify_field_unprotected Profiles, profile_id, "given_name", name
		modify_field_unprotected Profiles, profile_id, "family_name", faker.name.lastName()
		modify_field_unprotected Profiles, profile_id, "resume", resume

		console.log user.email
		user_ids.push user._id

	if callback
		callback user_ids

	return user_ids


#####################################################
_generate_challenges = (user_indices, callback) ->
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

		filter =
			owner_id: user._id
		profile = Profiles.findOne filter

		if error
			console.log error

			challenge_id = gen_challenge user._id
			content = "Random challenge by " + profile.given_name + ": " + faker.lorem.paragraphs(2)
			title = "Random challenge by " + profile.given_name + ": " + faker.lorem.sentence()

			modify_field_unprotected Challenges, challenge_id,	"content", content
			modify_field_unprotected Challenges, challenge_id,	"title", title
			modify_field_unprotected Challenges, challenge_id,	"name", title

			finish_challenge challenge_id

			challenge_ids.push challenge_id
			callback challenge_ids, user_indices
		else
			for d in data.jobs
				if UpworkTasks.findOne d.id
					continue

				content = d.snippet
				#.snippet.split('\n').join('<br>')
				title = d.title
				name = ": " + d.title
				content = "Upwork challenge by " +
								profile.given_name + ": " + content
				title = "Upwork challenge by " +
								profile.given_name + ": " + title

				challenge_id = gen_challenge user._id
				modify_field_unprotected Challenges, challenge_id, "content", content
				modify_field_unprotected Challenges, challenge_id, "title", title
				modify_field_unprotected Challenges, challenge_id, "name", name

				finish_challenge challenge_id
				challenge_ids.push challenge_id

			callback challenge_ids, user_indices

	bound = Meteor.bindEnvironment remote
	res = jobs.find params, bound

	console.log 'Challenge added.'
	return res

#####################################################
_generate_solutions = (challenge_id, user_indices) ->
	for u_index in user_indices
		challenge = Challenges.findOne challenge_id

		user = Accounts.findUserByEmail u_index+'@uni.edu'
		if not user
			console.log 'user not found: ' + u_index + '@uni.edu'
			return

		filter =
			owner_id: user._id
		profile = Profiles.findOne filter

		s_content = "Solution by " + profile.given_name + ": " + faker.lorem.paragraphs(3)
		solution_id = gen_solution challenge, user._id
		solution = Solutions.findOne solution_id

		modify_field_unprotected Solutions, solution_id, "visible_to", "anonymous"
		modify_field_unprotected Solutions, solution_id, "content", s_content
		request_review solution, user._id

		console.log 'solution added: ' + solution_id


#####################################################
_generate_reviews = (challenge_id, user_indices) ->
	for u_index in user_indices
		user = Accounts.findUserByEmail u_index+'@uni.edu'

		if not user
			console.log 'user not found: '+u_index+'@uni.edu'
			return

		#####################################################
		# preparing a review
		#####################################################

		filter =
			owner_id: user._id
		profile = Profiles.findOne filter

		chl_sol = find_solution_to_review user._id
		rev_fed = gen_review chl_sol.challenge, chl_sol.solution, user._id

		r_content = "Review by " + profile.given_name + ": " + faker.lorem.paragraphs(2)
		r_rating = Math.round(Math.random()*4, 0) + 1
		modify_field_unprotected Reviews, rev_fed.review_id, "content", r_content
		modify_field_unprotected Reviews, rev_fed.review_id, "rating", r_rating

		review = Reviews.findOne rev_fed.review_id
		finish_review review, user._id

		console.log 'review added: ' + rev_fed.review_id

		#####################################################
		# preparing the feedback to the review
		#####################################################

		feedback = Feedback.findOne rev_fed.feedback_id

		filter =
			owner_id: feedback.owner_id
		profile = Profiles.findOne filter

		f_content = "Feedback by " + profile.given_name + ": " + faker.lorem.paragraphs(1)
		f_rating = Math.round(Math.random()*4, 0) + 1
		modify_field_unprotected Feedback, rev_fed.feedback_id, "visible_to", "anonymous"
		modify_field_unprotected Feedback, rev_fed.feedback_id, "content", f_content
		modify_field_unprotected Feedback, rev_fed.feedback_id, "rating", f_rating

		console.log 'feedback added: ' + rev_fed.feedback_id

	return true


#####################################################
_simulate_users = (challenge_ids, user_indices) ->
	for c_id in challenge_ids
		_generate_solutions c_id, user_indices
		_generate_reviews c_id, user_indices

	Secrets.insert {wipe:false}


#####################################################
# start up
#####################################################
Meteor.methods
	test: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if !Roles.userIsInRole(user._id, 'db_admin')
			throw new Meteor.Error('Not permitted.')

		console.log "data generation"

		_generate_users(10)
		_generate_challenges([1..10], _simulate_users)

		return true


