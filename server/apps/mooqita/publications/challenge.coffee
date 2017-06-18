#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
# item header
#######################################################

#######################################################
_challenge_fields =
	fields:
		title: 1
		content: 1
		material: 1
		owner_id: 1
		published: 1
		num_reviews: 1


#######################################################
# challenges
#######################################################

#######################################################
Meteor.publish "challenges", (parameter) ->
	pattern =
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
	filter = visible_items user_id

	crs = paged_find Challenges, filter, _challenge_fields, parameter

	log_publication "Challenges", crs, filter,
			_challenge_fields, "challenges", user_id
	return crs


#######################################################
Meteor.publish "my_challenges", (parameter) ->
	pattern =
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
	restrict =
		owner_id: user_id

	filter = visible_items user_id, restrict

	if parameter.query
		filter.query = parameter.query

	crs = paged_find Challenges, filter, _challenge_fields, parameter

	log_publication "Challenges", crs, filter,
			_challenge_fields, "my_challenges", user_id
	return crs


#######################################################
Meteor.publish "challenge_by_id", (challenge_id) ->
	check challenge_id, String
	user_id = this.userId

	restrict =
		_id: challenge_id
		published: true

	filter = visible_items user_id, restrict
	crs = Challenges.find filter, _challenge_fields

	log_publication "Challenges", crs, filter,
			_challenge_fields, "challenge_by_id", user_id
	return crs


#######################################################
Meteor.publish "my_challenge_by_id", (challenge_id) ->
	user_id = this.userId

	restrict =
		_id:challenge_id
		owner_id: user_id

	filter = visible_items user_id, restrict
	crs = Challenges.find filter, _challenge_fields

	log_publication "Challenges", crs, filter,
			_challenge_fields, "my_challenge_by_id", user_id
	return crs


#######################################################
Meteor.publish "challenge_summary", (parameter) ->
	pattern =
		challenge_id: String
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	if parameter.size>20
		throw Meteor.Error("Size values larger than 20 are not allowed.")

	self = this
	user_id = this.userId
	challenge = Challenges.findOne parameter.challenge_id

	if challenge.owner_id != user_id
		throw Meteor.Error("Not permitted.")

	add_info = (solution) ->
		entry = {}
		entry.content = solution.content
		entry.material = solution.material
		entry.published = solution.published

		filter =
			owner_id: solution.owner_id

		profile = Profiles.findOne filter
		if profile
			entry["author_name"] = get_profile_name profile
			entry["author_avatar"] = get_avatar profile

		filter =
			parent_id: solution._id
			published: true

		options =
			fields:
				rating: 1
				content: 1
				owner_id: 1

		review_cursor = Reviews.find(filter, options)
		reviews = []
		avg = 0
		nt = 0

		review_cursor.forEach (review) ->
			r = {}
			r.content = review.content
			r.rating = review.rating

			filter =
				owner_id: review.owner_id

			profile = profile = Profiles.findOne(filter)
			if profile
				r["peer_name"] = get_profile_name profile
				r["peer_avatar"] = get_avatar profile

			reviews.push r
			avg += parseInt(r.rating)
			nt += 1

		avg = if nt then avg / nt else "no reviews yet"
		entry["reviews"] = reviews
		entry["average_rating"] = avg

		self.added("challenge_summary", solution._id, entry)

	filter =
		challenge_id: parameter.challenge_id

	if not Roles.userIsInRole user_id, "admin"
		filter.published = true

	options =
		fields:
			content: 1
			owner_id: 1
			published: 1
			challenge_id: 1
			reviews_required: 1

	crs = paged_find Solutions, filter, options, parameter
	crs.forEach(add_info)

	log_publication "Challenges", crs, filter,
			_challenge_fields, "challenge_summary", user_id

	self.ready()

