###############################################
@gen_profile = (user_id, occupation) ->
	if not occupation
		occupation = "student"

	profile =
		type_identifier: "profile"
		template_id: "profile"
		has_occupation: true
		occupation: occupation
		requested: 0
		provided: 0
		owner_id: user_id
		avatar: "data:image/png;base64,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"

	user = Meteor.users.findOne user_id
	if user.profile
		profile.given_name = user.profile.given_name
		profile.family_name = user.profile.family_name

	return save_document Responses, profile


###############################################
@gen_challenge = (user_id) ->
	challenge =
		type_identifier: "challenge"
		template_id: "challenge"
		owner_id: user_id

	return save_document Responses, challenge


###############################################
@finish_challenge = (challenge_id) ->
	modify_field_unprotected "Responses", challenge_id, "published", true


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
		published: false

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
	modify_field_unprotected "Responses", solution._id, "published", true

	return true


###############################################
@finish_review = (review, user_id) ->
	if not review.rating
		throw new Meteor.Error "Review: " + review._id + " Does not have a rating."

	if review.published
		throw new Meteor.Error "Review: " + review._id + " is already published"

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
	modify_field_unprotected "Responses", profile._id, "provided", profile.provided + 1
	modify_field_unprotected "Responses", review._id, "published", true

	if credits + 1 <= 0
		return

	filter =
		type_identifier: "solution"
		owner_id: user_id
		payed: false

	unpaid = Responses.findOne filter
	#modify_field_unprotected "Responses", unpaid._id, "paid", true


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
		published: true
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


