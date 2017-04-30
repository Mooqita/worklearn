###############################################
@gen_challenge = (user_id) ->
	challenge =
		type_identifier: "challenge"
		template_id: "challenge"
		owner_id: user_id
		unmatched: 0
		requested: 0

	return save_document Responses, challenge


###############################################
@finish_challenge = (challenge) ->
	modify_field_unprotected "Responses", challenge._id, "published", true
	modify_field_unprotected "Responses", challenge._id, "visible_to", "anonymous"

	#TODO: inform last round participants


###############################################
@gen_solution = (challenge, user_id) ->
	WordPOS = require("wordpos")
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
@finish_solution = (solution, user_id) ->
	modify_field_unprotected "Responses", solution._id, "published", true
	return request_review solution, user_id


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

	#TODO: enable is paid selections.
	#TODO: inform people on the waiting list for reviews.

	return true


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
	unmatched = solution.unmatched

	modify_field_unprotected "Responses", solution._id, "in_progress", in_progress + 1
	modify_field_unprotected "Responses", solution._id, "unmatched", unmatched - 1

	return data


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
	in_progress = solution.in_progress

	modify_field_unprotected "Responses", solution._id, "completed", completed + 1
	modify_field_unprotected "Responses", solution._id, "in_progress", in_progress - 1
	modify_field_unprotected "Responses", profile._id, "provided", profile.provided + 1
	modify_field_unprotected "Responses", review._id, "published", true

	#TODO: inform solution owner about a new review

	send_review_message review, user_id

	return review._id


###############################################
@finish_feedback = (feedback, user_id) ->
	if not feedback.rating
		throw new Meteor.Error "Feedback: " + feedback._id + " Does not have a rating."

	if feedback.published
		throw new Meteor.Error "Feedback: " + feedback._id + " is already published."

	send_feedback_message feedback, user_id

	return feedback._id


###############################################
@find_solution_to_review = (user_id, challenge_id=null) ->
	#solution must have unsatisfied review requests
	#solution owner must have enough credit to receive/request reviews
	#solution must be in the realm of the student
	#solution must be visible to others
	#solution is not owned by the reviewer

	corpus = collect_keywords user_id

	WordPOS = require("wordpos")
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
				throw new Meteor.Error "no-solution","solution not found"

	challenge = Responses.findOne solution.challenge_id

	if not solution
		throw new Meteor.Error "no-challenge","challenge not found"

	res =
		solution: solution
		challenge: challenge

	return res


