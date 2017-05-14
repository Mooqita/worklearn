###############################################
_num_requested_reviews  = (solution) ->
	if solution
		requester_id = solution.owner_id
	else
		requester_id = this.userId

	filter =
		requester_id: requester_id

	if solution
		filter.solution_id = solution._id

	res = ReviewRequests.find filter
	return  res.count()

###############################################
_num_provided_reviews = (solution) ->
	if solution
		requester_id = solution.owner_id
	else
		requester_id = this.userId

	filter =
		provider_id: requester_id
		review_id:
			$ne: ""

	if solution
		filter.solution_id = solution._id

	res = ReviewRequests.find filter
	return  res.count()


###############################################
@gen_challenge = (user_id) ->
	challenge =
		type_identifier: "challenge"
		template_id: "challenge"
		owner_id: user_id

	return store_document Challenges, challenge


###############################################
@finish_challenge = (challenge) ->
	modify_field_unprotected Challenges, challenge._id, "published", true
	modify_field_unprotected Challenges, challenge._id, "visible_to", "anonymous"

	#TODO: inform last round participants


###############################################
@gen_solution = (challenge, user_id) ->
	solution =
		name: "Solution: " + challenge.title
		index: 1
		owner_id: user_id
		parent_id: challenge._id
		view_order: 1
		group_name: ""
		template_id: "solution"
		challenge_id: challenge._id
		type_identifier: "solution"
		published: false

	store_document Solutions, solution


###############################################
@finish_solution = (solution, user_id) ->
	if solution.published
		throw new Meteor.Error "Review: " + review._id + " is already published"

	modify_field_unprotected Solutions, solution._id, "published", true
	return request_review solution, user_id


###############################################
@request_review = (solution, user_id) ->
	requested = _num_requested_reviews solution
	provided = _num_provided_reviews solution
	credits = provided - requested

	if credits < 0
		throw new Meteor.Error "User needs more credits to request reviews."

	#TODO: enable is paid selections.
	#TODO: inform people on the waiting list for reviews.

	#WordPOS = require("wordpos")
	#wordpos = new WordPOS()
	#text_index = wordpos.parse challenge.content

	rr =
		challenge_id: solution.challenge_id
		solution_id: solution._id
		review_id: ""
		review_done: false
		feedback_id: ""
		feedback_done: false
		provider_id: ""
		requester_id: user_id
		under_review_since: new Date((new Date())-1000*60*60*25)
#		text_index: text_index.join().toLowerCase()

	rr_id = ReviewRequests.insert rr
	return rr_id


###############################################
@find_solution_to_review = (user_id, challenge_id=null) ->
	#solution must have unsatisfied review requests
	#solution owner must have enough credit to receive/request reviews
	#solution must be in the realm of the student
	#solution must be visible to others
	#solution is not owned by the reviewer

#	corpus = collect_keywords user_id

#	WordPOS = require("wordpos")
#	wordpos = new WordPOS()
#	text_index = wordpos.parse corpus

	filter =
		under_review_since:
			$lt: new Date((new Date())-1000*60*60*24)
		review_done: false
		requester_id:
			$ne: user_id
#		$text:
#			$search: text_index.join().toLowerCase()

	rr = ReviewRequests.findOne filter

	if not rr
		throw new Meteor.Error "no-solution","There are no solutions to review at the moment."

	challenge = Challenges.findOne rr.challenge_id
	if not challenge
		throw new Meteor.Error "no-challenge","challenge not found"

	solution = Solutions.findOne rr.solution_id
	if not solution
		throw new Meteor.Error "no-solution","solution not found"

	return rr


###############################################
@gen_review = (review_request, user_id) ->
	if review_request.review_id
		review Reviews.findOne review_request.review_id
		send_review_timeout_message review
		Reviews.remove review_request.review_id

	if review_request.feedback_id
		Feedback.remove review_request.feedback_id

	review_id = Random.id()
	solution = Solutions.findOne review_request.solution_id
	challenge = Challenges.findOne review_request.challenge_id

	review =
		_id: review_id
		index: 1
		owner_id: user_id
		parent_id: solution._id
		solution_id: solution._id
		challenge_id: challenge._id
		view_order: 1
		group_name: ""
		visible_to: "owner"
		template_id: "review"

	feedback =
		index: 1
		owner_id: solution.owner_id
		parent_id: review_id
		review_id: review_id
		solution_id: solution._id
		challenge_id: challenge._id
		view_order: 1
		group_name: ""
		visible_to: "owner"
		template_id: "feedback"

	r_id = store_document Reviews, review
	f_id = store_document Feedback, feedback

	modify_field_unprotected ReviewRequests,
		review_request._id, "under_review_since", new Date()

	modify_field_unprotected ReviewRequests,
		review_request._id, "provider_id", user_id

	modify_field_unprotected ReviewRequests,
		review_request._id, "review_id", r_id

	modify_field_unprotected ReviewRequests,
		review_request._id, "feedback_id", f_id

	return r_id


###############################################
@finish_review = (review, user_id) ->
	if not review.rating
		throw new Meteor.Error "Review: " + review._id + " Does not have a rating."

	if review.published
		throw new Meteor.Error "Review: " + review._id + " is already published"

	filter =
		review_id: review._id
	rr = ReviewRequests.findOne filter

	modify_field_unprotected Reviews, review._id, "published", true
	modify_field_unprotected ReviewRequests, rr._id, "review_done", true
	modify_field_unprotected ReviewRequests, rr._id, "review_finished", new Date()
	send_review_message review

	return review._id


###############################################
@finish_feedback = (feedback, user_id) ->
	if not feedback.rating
		throw new Meteor.Error "Feedback: " + feedback._id + " Does not have a rating."

	if feedback.published
		throw new Meteor.Error "Feedback: " + feedback._id + " is already published."

	filter =
		feedback_id: feedback._id
	rr = ReviewRequests.findOne filter

	modify_field_unprotected Feedback, feedback._id, "published", true
	modify_field_unprotected ReviewRequests, rr._id, "feedback_done", true
	modify_field_unprotected ReviewRequests, rr._id, "feedback_finished", new Date()
	feedback = Feedback.findOne feedback._id

	send_feedback_message feedback
	return feedback._id


