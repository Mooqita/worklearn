#######################################################
@get_avatar = (profile) ->
	avatar = ""

	if profile.avatar
		if typeof profile.avatar == "number"
			avatar = download_dropbox_file Profiles, profile._id, "avatar"
		else
			avatar = profile.avatar


###############################################
@secure_item_action = (collection, item_id, owner = true) ->
	check item_id, String

	user = Meteor.user()

	if not user
		throw new Meteor.Error("Not permitted.")

	item = collection.findOne item_id
	if not item
		throw new Meteor.Error("Not permitted.")

	if owner
		if item.owner_id != user._id
			throw new Meteor.Error("Not permitted.")

	return item

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


