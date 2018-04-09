###############################################
@num_requested_reviews  = (solution) ->
	if solution
		requester_id = get_document_owner "solutions", solution
	else
		requester_id = this.userId

	filter =
		requester_id: requester_id

	if solution
		filter.challenge_id = solution.challenge_id

	res = Reviews.find filter
	return res.count()

###############################################
@num_provided_reviews = (solution) ->
	if solution
		requester_id = get_document_owner "solutions", solution
	else
		requester_id = this.userId

	filter =
		published: true

	if solution
		filter.challenge_id = solution.challenge_id

	res = get_documents requester_id, OWNER, "reviews", filter
	return  res.count()


