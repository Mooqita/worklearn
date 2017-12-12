###############################################
@request_review = (solution, user) ->
	requested = num_requested_reviews solution
	provided = num_provided_reviews solution
	credits = provided - requested

	if not Roles.userIsInRole user, "challenge_designer"
		if credits < 0
			throw new Meteor.Error "User needs more credits to request reviews."

	#WordPOS = require("wordpos")
	#wordpos = new WordPOS()
	#text_index = wordpos.parse challenge.content

	review_id = Random.id()
	challenge = Challenges.findOne solution.challenge_id

	review =
		_id: review_id
		solution_id: solution._id
		challenge_id: challenge._id
		requester_id: solution.owner_id
		requested: new Date()
		assigned: false
		published: false

	store_document_unprotected Reviews, review, null
	gen_feedback solution, review, user

	msg = "Solution (" + solution.id + ") review requested by: " + get_user_mail user
	log_event msg, event_logic, event_info

	return review_id


###############################################
_find_review = (user, challenge) ->
	# find all solutions this user has already reviewed
	filter =
		owner_id: user._id

	mod =
		fields:
			solution_id: 1

	crs = Reviews.find(filter, mod).fetch()

	handled = _.uniq(_.pluck(crs, 'solution_id'))

	# find the keywords for the user to make sure they understand what they review
	#corpus = collect_keywords user._id
	#WordPOS = require("wordpos")
	#wordpos = new WordPOS()
	#text_index = wordpos.parse corpus

	# Find reviews for the reviewer that satisfy these requirements:
	# The requester of the review is not the reviewer (this user)
	# Not yet published
	# Either not assigned to a reviewer or not changed in the last 24 hours
	# The solution is not yet reviewed by the reviewer (this user)
	# The user has expertise for the solution
	filter =
		requester_id:
			$ne: user._id
		published: false
		$or:[	{assigned: false}
					{modified:
						$lt: new Date((new Date())-1000*60*60*24)}]
		solution_id:
			$nin: handled
#		$text:
#			$search: text_index.join().toLowerCase()

	# Sort so that the oldest review is selected first
	mod =
		sort:
			modified: 1

	# If a challenge is defined we restrict the search further
	if challenge
		filter.challenge_id = challenge._id

	return Reviews.findOne filter, mod


###############################################
@assign_review = (challenge, solution, user) ->
	if solution
		filter =
			solution_id: solution._id
			published: false
		review = Reviews.findOne filter
	else
		review = _find_review user, challenge

	if not review
		throw new Meteor.Error "no-review", "There are no solutions to review at the moment."

	if not challenge
		challenge = Challenges.findOne review.challenge_id

		if not challenge
			throw new Meteor.Error "no-challenge", "challenge not found"

	solution = Solutions.findOne review.solution_id
	if not solution
		throw new Meteor.Error "no-solution","solution not found"

	if review.assigned
		send_review_timeout_message review

	modify_field_unprotected Reviews, review._id, "owner_id", user._id
	modify_field_unprotected Reviews, review._id, "assigned", true

	res =
		review_id: review._id
		solution_id: solution._id
		challenge_id: challenge._id

	msg = "Review (" + review._id + ") review found for: " + get_user_mail user
	log_event msg, event_logic, event_info

	return res


###############################################
@finish_review = (review, user) ->
	if not review.rating
		throw new Meteor.Error "Review: " + review._id + " Does not have a rating."

	if review.published
		throw new Meteor.Error "Review: " + review._id + " is already published"

	modify_field_unprotected Reviews, review._id, "published", true
	send_review_message review

	# Find the solution the review provider submitted.
	# The solution has to be submitted to the same challenge
	# as the solution in the review.
	filter =
		requester_id: review.owner_id
		challenge_id: review.challenge_id

	request = Reviews.findOne filter
	if not request
		if Roles.userIsInRole review.owner_id, "tutor"
			return review._id

		throw new Meteor.Error "A non tutor provided a review without a solution."

	solution = Solutions.findOne request.solution_id
	challenge = Challenges.findOne review.challenge_id

	requested = num_requested_reviews solution
	required = 	challenge.num_reviews

	r_owner = Meteor.users.findOne review.owner_id

	if solution.published
		if required > requested
			request_review solution, r_owner

	msg = "Review (" + review._id + ") review finished by: " + get_user_mail user
	log_event msg, event_logic, event_info

	return review._id


###############################################
@reopen_review = (review, user) ->
	if !review.published
		return review._id

	# we can reopen a review when:
	# The feedback has no content yet

	filter =
		review_id: review._id
		published: false

	feedback = Feedback.find filter

	# There are no assigned reviews that
	# have been touched in the last 24 hours
	for f in feedback
		if f.content
			throw new Meteor.Error "in-progress", "The Review already has feedback."

	modify_field_unprotected Reviews, review._id, "published", false

	msg = "Review (" + review.id + ") reopened by: " + get_user_mail user
	log_event msg, event_logic, event_info

	return review._id

