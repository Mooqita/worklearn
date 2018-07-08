###############################################################################
# Calculate statistics for a user and a
# given cursor of reviews\feedback
###############################################################################

###############################################################################
@calc_statistics = (entry, cursor, prefix) ->
	math = require 'mathjs'

	length = 0
	ratings = []
	count = cursor.count()
	cursor.forEach (e) ->
		if e.content
			length += e.content.split(" ").length
		if e.rating
			ratings.push e.rating

	avg = math.sum ratings / count

	entry[prefix+"_count"] = count
	entry[prefix+"_average_length"] = length / count
	entry[prefix+"_average_rating"] = avg
	entry[prefix+"_rating_bias"] = avg - 2.5
	entry[prefix+"_rating_sd"] = if ratings.length then math.std(ratings) else 0.0
	entry[prefix] = cursor.fetch()

	return entry


###############################################################################
@gen_resume = (user) ->
	resume = {}
	profile = get_profile user

	if profile
		resume.given_name = profile.given_name
		resume.avatar = get_avatar(profile)
		resume.resume = profile.resume

	solution_list = []
	solution_cursor = get_documents user, OWNER, Solutions, {published: true}

	solution_cursor.forEach (s) ->
		if not s.published
			return

		challenge = Challenges.findOne(s.challenge_id)
		confidential = challenge.confidential

		solution = {}
		solution.id = fast_hash(s._id).split("#")[1]
		solution.content = if confidential then "under NDA" else s.content
		solution.reviews = []
		solution.challenge = {}

		if challenge
			solution.challenge.id = challenge._id
			solution.challenge.title = challenge.title
			solution.challenge.content = if confidential then "under NDA" else challenge.content

			challenge_owner = get_document_owner Challenges, challenge
			challenge_owner_profile = get_document challenge_owner, OWNER, Profiles

			if profile
				solution.challenge.owner_avatar = get_avatar challenge_owner_profile

		abs_rating = 0
		num_ratings = 0

		review_filter =
			solution_id: s._id
		review_cursor = Reviews.find(review_filter)

		review_cursor.forEach (r) ->
			review = {}
			review.id = fast_hash(r._id).split("#")[1]
			review_owner = get_document_owner Reviews, r._id
			review_owner_profile = get_profile review_owner

			if profile
				review.owner_avatar = get_avatar review_owner_profile
				review.owner_name = get_profile_name review_owner_profile

			filter =
				review_id: r._id
			feedback = Feedback.findOne filter

			if feedback.published
				review.feedback = {}
				review.feedback.content = feedback.content
				review.feedback.rating = feedback.rating
				review.rating = r.rating
				abs_rating += parseInt(r.rating)
				num_ratings += 1

			review.review = r.content
			solution.reviews.push(review)

		if abs_rating
			avg = Math.round(abs_rating / num_ratings)
			solution.average = avg

		solution_list.push(solution)

	resume.solutions = solution_list
	return resume
