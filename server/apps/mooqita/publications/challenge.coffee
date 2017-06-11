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
Meteor.publish "challenges", (parameter={}, page=0, size=10) ->
	check parameter, Match.OneOf({query:String},{})
	check page, Number
	check size, Number

	user_id = this.userId
	filter = visible_items user_id
	fields = _challenge_fields.fields

	if parameter.query
		filter["$text"] =
			$search: parameter.query
		fields.score = {$meta: "textScore"}

	mod =
		fields: fields
		limit: size
		skip: size*page

	if parameter.query
		mod.sort =
			score:
				$meta: "textScore"

	crs = Challenges.find filter, mod

	log_publication "Challenges", crs, filter,
			_challenge_fields, "challenges", user_id
	return crs


#######################################################
Meteor.publish "my_challenges", (parameter={}, page=0, size=10) ->
	user_id = this.userId
	restrict =
		owner_id: user_id

	filter = visible_items user_id, restrict
	crs = Challenges.find filter, _challenge_fields

	log_publication "Challenges", crs, filter,
			_challenge_fields, "my_challenge", user_id
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
Meteor.publish "challenge_summary", (challenge_id, page=0, size=10) ->
	check challenge_id, String
	check page, Number
	check size, Number

	if size>10
		throw Meteor.Error("Size values larger than 10 are not allowed.")

	self = this
	user_id = this.userId
	challenge = Challenges.findOne challenge_id

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
		parent_id: challenge_id

	if not Roles.userIsInRole user_id, "admin"
		filter.published = true

	options =
		fields:
			content: 1
			owner_id: 1
			published: 1
			challenge_id: 1
			reviews_required: 1
		skip: page * size
		limit: size

	crs = Solutions.find(filter, options)
	crs.forEach(add_info)

	log_publication "Challenges", crs, filter,
			_challenge_fields, "challenge_summary", user_id

	self.ready()

