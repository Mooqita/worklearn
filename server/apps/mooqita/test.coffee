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
	console.log "[edit] User reset: " + user_id


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

		console.log "[info]" + user.email
		user_ids.push user._id

	if callback
		callback user_ids

	return user_ids


#####################################################
_generate_challenges = (user_indices, callback) ->
	user  = Accounts.findUserByEmail '1@uni.edu'
	challenge_ids = []

	filter =
		owner_id: user._id
	profile = Profiles.findOne filter

	challenge_id = gen_challenge user._id
	content = "Random challenge by " + profile.given_name + ": " + faker.lorem.paragraphs(2)
	title = "Random challenge by " + profile.given_name + ": " + faker.lorem.sentence()

	modify_field_unprotected Challenges, challenge_id,	"content", content
	modify_field_unprotected Challenges, challenge_id,	"title", title
	modify_field_unprotected Challenges, challenge_id,	"name", title

	finish_challenge challenge_id

	challenge_ids.push challenge_id
	return challenge_ids

#####################################################
_generate_solutions = (challenge_id, user_indices) ->
	for u_index in user_indices
		challenge = Challenges.findOne challenge_id

		user = Accounts.findUserByEmail u_index+'@uni.edu'
		if not user
			console.log '[error] user not found: ' + u_index + '@uni.edu'
			return

		filter =
			owner_id: user._id
		profile = Profiles.findOne filter

		s_content = "Solution by " + profile.given_name + ": " + faker.lorem.paragraphs(3)
		solution_id = gen_solution challenge, user._id
		solution = Solutions.findOne solution_id

		modify_field_unprotected Solutions, solution_id, "content", s_content
		finish_solution solution, user._id

		console.log '[edit] solution added: ' + solution_id


#####################################################
_generate_reviews = (challenge_id, user_indices) ->
	for u_index in user_indices
		user = Accounts.findUserByEmail u_index+'@uni.edu'

		if not user
			console.log '[error] user not found: '+u_index+'@uni.edu'
			return

		#####################################################
		# preparing a review
		#####################################################

		filter =
			owner_id: user._id
		profile = Profiles.findOne filter

		review_id = gen_review user._id

		r_content = "Review by " + profile.given_name + ": " + faker.lorem.paragraphs(2)
		r_rating = Math.round(Math.random()*4, 0) + 1
		modify_field_unprotected Reviews, review_id, "content", r_content
		modify_field_unprotected Reviews, review_id, "rating", r_rating

		review = Reviews.findOne review_id
		finish_review review, user._id

		console.log '[edit] review added: ' + review_id

		#####################################################
		# preparing the feedback to the review
		#####################################################
		filter =
			review_id: review_id

		feedback = Feedback.findOne filter

		filter =
			owner_id: feedback.owner_id
		profile = Profiles.findOne filter

		f_content = "Feedback by " + profile.given_name + ": " + faker.lorem.paragraphs(1)
		f_rating = Math.round(Math.random()*4, 0) + 1
		modify_field_unprotected Feedback, feedback._id, "visible_to", "anonymous"
		modify_field_unprotected Feedback, feedback._id, "content", f_content
		modify_field_unprotected Feedback, feedback._id, "rating", f_rating

		console.log '[edit] feedback added: ' + feedback._id

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

		console.log "[test] data generation"

		_generate_users(10)
		_generate_challenges([1..10], _simulate_users)

		return true


