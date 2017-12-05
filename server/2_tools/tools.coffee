###############################################
@num_requested_reviews  = (solution) ->
	if solution
		requester_id = solution.owner_id
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
		requester_id = solution.owner_id
	else
		requester_id = this.userId

	filter =
		owner_id: requester_id
		published: true

	if solution
		filter.challenge_id = solution.challenge_id

	res = Reviews.find filter
	return  res.count()


