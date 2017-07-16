#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
# Resumes
#######################################################

#######################################################
Meteor.publish "user_credentials", (user_id) ->
	check user_id, String

	if user_id
		if not Roles.userIsInRole this.userId, "admin"
			throw new Meteor.Error("Not permitted.")

	if !user_id
		user_id = this.userId

	if !user_id
		throw new Meteor.Error("Not permitted.")

	self = this
	prepare_resume = (user) ->
		resume = {}

		filter =
			owner_id: user._id

		profile = Profiles.findOne filter

		if profile
			resume.name = get_profile_name profile
			resume.owner_id = profile._id
			resume.self_description = profile.resume
			resume.avatar = get_avatar profile

		solution_filter =
			published: true
			owner_id: user._id
			#in_portfolio: true

		solution_list = []
		solution_cursor = Solutions.find solution_filter

		solution_cursor.forEach (s) ->
			solution = {}
			solution.reviews = []
			solution.solution = if !s.confidential then s.content else null

			challenge = Challenges.findOne(s.challenge_id)
			if challenge
				solution.challenge = if !challenge.confidential then challenge.content else null
				solution.challenge_title = challenge.title

				filter =
					owner_id: challenge.owner_id
				profile = Profiles.findOne filter

				if profile
					solution.challenge_owner_avatar = get_avatar profile

			abs_rating = 0
			num_ratings = 0

			review_filter =
				solution_id: s._id
			review_cursor = Reviews.find(review_filter)

			review_cursor.forEach (r) ->
				review = {}

				filter =
					parent_id: r._id
				feedback = Feedback.findOne filter

				filter =
					owner_id: r.owner_id
				profile = Profiles.findOne filter

				if feedback.published
					review.rating = r.rating
					abs_rating += parseInt(r.rating)
					num_ratings += 1
					if profile
						review.name = get_profile_name profile
						review.avatar = get_avatar profile

				review.review = r.content
				solution.reviews.push(review)

			if abs_rating
				avg = Math.round(abs_rating / num_ratings, 1)
				solution.average = avg

			solution_list.push(solution)

		resume.solutions = solution_list
		self.added("user_credentials", user._id, resume)

	filter =
		_id: user_id

	crs = Meteor.users.find(filter)
	crs.forEach(prepare_resume)

	log_publication "UserCredentials", crs, filter, {}, "credits", user_id
	self.ready()

#######################################################
Meteor.publish "user_summary", (user_id) ->
	check user_id, String

	if user_id
		if not Roles.userIsInRole this.userId, "challenge_designer"
			throw new Meteor.Error("Not permitted.")

	if !user_id
		user_id = this.userId

	if !user_id
		throw new Meteor.Error("Not permitted.")

	mod =
		fields:
			emails: 1

	user = Meteor.users.findOne user_id, mod
	match =
		$match:
			requester_id:
				user_id

	group =
		$group:
			_id: '$requester_id'
			result:
				$avg: '$rating'

	mod =
		fields:
			content: 1
			material: 1

	filter =
		owner_id: user_id

	length = 0
	upload = 0
	solutions = Solutions.find filter, mod
	solutions.forEach (entry) ->
		if entry.content
			length += entry.content.split(" ").length
		upload += if entry.material then 1 else 0

	tmp = Reviews.aggregate(match, group)[0]
	user.average_solution_quality = if tmp then tmp.result else undefined
	user.solution_length = length / solutions.count()
	user.solution_upload = upload
	user.solution_count = solutions.count()
	user.solutions = solutions.fetch()

	length = 0
	reviews = Reviews.find filter, mod
	reviews.forEach (entry) ->
		if entry.content
			length += entry.content.split(" ").length

	tmp = Feedback.aggregate(match, group)[0]
	user.average_review_quality = if tmp then tmp.result else undefined
	user.review_length = length / reviews.count()
	user.review_count = reviews.count()
	user.reviews = reviews.fetch()

	this.added "user_summaries", user_id, user
	this.ready()