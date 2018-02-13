#######################################################
#
#	Mooqita
# Created by Markus on 20/8/2017.
#
#######################################################

#######################################################
Meteor.publish "find_users_by_mail": (mail_fragment) ->
	user = Meteor.user()
	if not user
		throw new Meteor.Error('Not permitted.')

	if mail_fragment.length < 5
		return []

	check mail_fragment, String
	filter =
		emails:
			$elemMatch:
				address:
					$regex : new RegExp(mail_fragment, "i")

	options =
		fields:
			emails: 1
		skip: 0,
		limit: 10

	crs = Meteor.users.find filter, options
	users = crs.fetch()

	return users

#######################################################
Meteor.publish "my_profile", () ->
	user_id = this.userId

	if not user_id
		user_id = ""

	filter =
		user_id: user_id

	crs = Profiles.find filter
	log_publication crs, user_id, "my_profile"

	return crs

#######################################################
# Resumes
#######################################################

#######################################################
Meteor.publish "user_resumes", (user_id) ->
	if user_id
		check user_id, String
		if not has_role Profiles, WILDCARD, this.userId, ADMIN
			if this.userId != user_id
				profile = get_document user_id, "owner", Profiles
				if profile.locale
					throw new Meteor.Error("Not permitted.")

	if !user_id
		user_id = this.userId

	if !user_id
		throw new Meteor.Error("Not permitted.")

	self = this
	prepare_resume = (user) ->
		resume = {}
		profile = get_profile user

		if profile
			resume.name = get_profile_name profile, false, false
			resume.self_description = profile.resume
			resume.avatar = get_avatar profile

		solution_list = []
		solution_cursor = get_documents user, OWNER, Solutions, {published: true}

		solution_cursor.forEach (s) ->
			solution = {}
			solution.reviews = []
			solution.solution = if !s.confidential then s.content else null

			challenge = Challenges.findOne(s.challenge_id)
			if challenge
				solution.challenge = if !challenge.confidential then challenge.content else null
				solution.challenge_title = challenge.title

				owner = get_document_owner Challenges, challenge
				profile = get_document owner, OWNER, Profiles

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
					review_id: r._id
				feedback = Feedback.findOne filter

				owner = get_document_owner Profiles, r
				profile = get_profile owner

				if feedback.published
					review.feedback = {}
					review.feedback.content = feedback.content
					review.feedback.rating = feedback.rating
					review.rating = r.rating
					abs_rating += parseInt(r.rating)
					num_ratings += 1
					if profile
						review.name = get_profile_name profile ,false ,false
						review.avatar = get_avatar profile

				review.review = r.content
				solution.reviews.push(review)

			if abs_rating
				avg = Math.round(abs_rating / num_ratings, 1)
				solution.average = avg

			solution_list.push(solution)

		resume.solutions = solution_list
		self.added("user_resumes", user._id, resume)

	filter =
		_id: user_id

	crs = Meteor.users.find(filter)
	crs.forEach(prepare_resume)

	log_publication crs, user_id, "user_resumes"
	self.ready()

#######################################################
Meteor.publish "user_summary", (user_id, challenge_id) ->
	check user_id, String
	check challenge_id, String

	if user_id
		if not has_role Challenges, challenge_id, this.userId, DESIGNER
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
	filter = {challenge_id: challenge_id}
	solutions = get_my_documents filter, mod

	##########################################
	# Find relevant Feedback and Reviews
	##########################################
	rev_given = get_my_documents Reviews.find filter, mod
	fed_given = get_my_documents Feedback.find filter, mod

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

	log_publication crs, this.userId, "user_summary"
	this.added "user_summaries", user_id, user
	this.ready()