###############################################
@gen_profile = (user_id) ->
	profile =
		type_identifier: "profile"
		template_id: "profile"
		owner_id: user_id
		provided: 0
		requested: 0

	return save_document Responses, profile


###############################################
@gen_challenge = (user_id) ->
	challenge =
		type_identifier: "challenge"
		template_id: "challenge"
		owner_id: user_id

	return save_document Responses, challenge


###############################################
@gen_solution = (challenge, user_id) ->
	WordPOS = require('wordpos')
	wordpos = new WordPOS()
	text_index = wordpos.parse challenge.content

	solution =
		name: "Solution: " + challenge.title
		index: 1
		owner_id: user_id
		parent_id: challenge._id
		view_order: 1
		group_name: ""
		text_index: text_index.join().toLowerCase()
		template_id: "solution"
		challenge_id: challenge._id
		type_identifier: "solution"
		requested: 0
		in_progress: 0
		completed: 0
		unmatched: 0

	save_document Responses, solution


###############################################
@gen_review = (challenge, solution, user_id) ->
	review_id = Random.id()

	review =
		_id: review_id
		index: 1
		owner_id: user_id
		parent_id: solution._id
		solution_id: solution._id
		challenge_id: challenge._id
		view_order: 1
		group_name: ""
		template_id: "review"
		type_identifier: "review"

	feedback =
		index: 1
		owner_id: solution.owner_id
		parent_id: review_id
		solution_id: solution._id
		challenge_id: challenge._id
		view_order: 1
		group_name: ""
		visible_to: "owner"
		template_id: "feedback"
		type_identifier: "feedback"

	r_id = save_document Responses, review
	f_id = save_document Responses, feedback

	data =
		review_id: r_id
		feedback_id: f_id

	in_progress = solution.in_progress
	modify_field_unprotected "Responses", solution._id, "in_progress", in_progress + 1

	return data


###############################################
@request_review = (solution, user_id) ->
	filter =
		type_identifier: "profile"
		owner_id: user_id

	profile = Responses.findOne filter
	credits = profile.provided - profile.requested

	if credits < 0
		throw new Meteor.Error "User needs more credits to request reviews."

	requested = solution.requested
	unmatched = solution.unmatched

	modify_field_unprotected "Responses", profile._id, "requested", profile.requested + 1

	modify_field_unprotected "Responses", solution._id, "unmatched", unmatched + 1
	modify_field_unprotected "Responses", solution._id, "requested", requested + 1
	modify_field_unprotected "Responses", solution._id, "paid", credits > 0


###############################################
@finish_review = (review, user_id) ->
	if not review.rating
		throw new Meteor.Error "Review: " + review._id + " Does not have a rating."

	filter =
		type_identifier: "profile"
		owner_id: user_id

	profile = Responses.findOne filter
	credits = profile.provided - profile.requested

	solution = Responses.findOne review.solution_id
	completed = solution.completed
	unmatched = solution.unmatched
	in_progress = solution.in_progress

	modify_field_unprotected "Responses", solution._id, "completed", completed + 1
	modify_field_unprotected "Responses", solution._id, "in_progress", in_progress - 1
	modify_field_unprotected "Responses", solution._id, "unmatched", unmatched - 1
	modify_field_unprotected "Responses", review._id, "visible_to", "anonymous"
	modify_field_unprotected "Responses", profile._id, "provided", profile.provided + 1

	if credits + 1 <= 0
		return

	filter =
		type_identifier: "solution"
		owner_id: user_id
		payed: false

	unpaid = Responses.findOne filter
	modify_field_unprotected "Responses", unpaid._id, "paid", true


###############################################
@find_solution_to_review = (user_id, challenge_id=null) ->
	#solution must have unsatisfied review requests
	#solution owner must have enough credit to receive/request reviews
	#solution must be in the realm of the student
	#solution must be visible to others
	#solution is not owned by the reviewer

	corpus = collect_keywords user_id

	WordPOS = require('wordpos')
	wordpos = new WordPOS()
	text_index = wordpos.parse corpus

	filter =
		type_identifier: "solution"
		visible_to: "anonymous"
		unmatched:
			$gt: 0
		owner_id:
			$ne: user_id
		$text:
			$search: text_index.join().toLowerCase()

	solution = Responses.findOne filter

	if not solution
		throw  new Meteor.Error 'solution not found'

	challenge = Responses.findOne solution.challenge_id

	if not solution
		throw  new Meteor.Error 'challenge not found'

	res =
		solution: solution
		challenge: challenge

	return res


###############################################
Meteor.methods
	add_solution: (challenge_id) ->
		check challenge_id, String
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		challenge = Responses.findOne challenge_id
		if not challenge
			throw new Meteor.Error('Not permitted.')

		return gen_solution challenge, Meteor.userId()


	find_review: (profile_id) ->
		check profile_id, String
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		profile = Responses.findOne profile_id

		if user._id != profile.owner_id
			throw new Meteor.Error('Not permitted.')

		chl_sol = find_solution_to_review user._id
		rev_fed = gen_review chl_sol.challenge, chl_sol.solution, user._id

		return rev_fed.review_id

	find_review_for_challenge: (profile_id, challenge_id) ->
		check profile_id, String
		check challenge_id, String

		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		profile = Responses.findOne profile_id

		if user._id != profile.owner_id
			throw new Meteor.Error('Not permitted.')

		chl_sol = find_solution_to_review user._id, challenge_id
		rev_fed = gen_review chl_sol.challenge, chl_sol.solution, user._id

		return rev_fed.review_id

	add_upwork_challenge: (response) ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if !Roles.userIsInRole(user._id, 'db_admin')
			throw new Meteor.Error('Not permitted.')

		response.visible_to = "owner"
		response.owner_id = Meteor.userId()

		Responses.insert response

