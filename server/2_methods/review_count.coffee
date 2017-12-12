###############################################
@num_requested_reviews  = (solution) ->
	if solution
		owner = get_document_owner "solutions", solution
		requester_id = owner._id
	else
		requester_id = this.userId

	filter =
		requester_id: requester_id

	if solution
		filter.challenge_id = solution.challenge_id

	res = Reviews.find filter
	return  res.count()

###############################################
@num_provided_reviews = (solution) ->
	if solution
		owner = get_document_owner "solutions", solution
		requester_id = owner._id
	else
		requester_id = this.userId

	filter =
		published: true

	if solution
		filter.challenge_id = solution.challenge_id

	res = get_document requester_id, OWNER, "reviews", filter
	return  res.count()


