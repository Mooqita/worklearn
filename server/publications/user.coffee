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
Meteor.publish "user_summary", (user_id, challenge_id) ->
	check user_id, String
	check challenge_id, String

	if user_id
		if not Roles.userIsInRole this.userId, "challenge_designer"
			throw new Meteor.Error("Not permitted.")

	if !user_id
		user_id = this.userId

	if !user_id
		throw new Meteor.Error("Not permitted.")

	##########################################
	# Initialize user summary through users
	# database object
	##########################################

	mod =
		fields:
			emails: 1

	user = Meteor.users.findOne user_id, mod

	##########################################
  # Same fields for solution review feedback
	##########################################
	mod =
		fields:
			rating: 1
			content: 1
			material: 1

	##########################################
	# Find Solutions
	##########################################

	##########################################
	filter =
		owner_id: user_id
		challenge_id: challenge_id

	solutions = Solutions.find filter, mod

	##########################################
	# Find relevant Feedback and Reviews
	##########################################
	filter =
		owner_id: user_id
		challenge_id: challenge_id
	rev_given = Reviews.find filter, mod
	fed_given = Feedback.find filter, mod

	filter =
		requester_id: user_id
		challenge_id: challenge_id
	rev_received = Reviews.find filter, mod
	fed_received = Feedback.find filter, mod

	##########################################
	#
	# Calculate statistics
	#
	##########################################

	##########################################
	# Solutions
	##########################################
	material = 0
	length = 0
	count = solutions.count()
	solutions.forEach (entry) ->
		if entry.content
			length += entry.content.split(" ").length
		if entry.material
			material += 1

	user.solutions_count = count
	user.solutions_average_length = length / count
	user.solutions_average_material = material / count

	##########################################
	# Given Reviews
	##########################################
	user = calc_statistics user, rev_given, "reviews_given"
	user = calc_statistics user, rev_received, "reviews_received"
	user = calc_statistics user, fed_given, "feedback_given"
	user = calc_statistics user, fed_received, "feedback_received"

	msg = "UserSummaries for: " + get_profile_name_by_user_id user_id, true

	log_publication msg, null, {},
			{}, "user_summary", this.userId

	this.added "user_summaries", user_id, user
	this.ready()