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
_solution_fields =
	fields:
		content: 1
		material: 1
		owner_id: 1
		completed: 1
		published: 1
		parent_id: 1
		challenge_id: 1

#######################################################
_review_fields =
	fields:
		rating: 1
		content: 1
		published: 1
		parent_id: 1
		solution_id: 1
		challenge_id: 1

#######################################################
_feedback_fields =
	fields:
		rating: 1
		content: 1
		parent_id: 1
		published: 1
		solution_id: 1
		challenge_id: 1


#######################################################
_get_avatar = (profile) ->
	avatar = ""

	if profile.avatar
		if typeof profile.avatar == "number"
			avatar = download_dropbox_file Profiles, profile._id, "avatar"
		else
			avatar = profile.avatar


#######################################################
# challenges
#######################################################

#######################################################
Meteor.publish "challenges", (query="", page=0, size=10) ->
	check query, String
	check page, Number
	check size, Number

	user_id = this.userId
	filter = visible_items user_id
	fields = _challenge_fields.fields

	if query
		filter["$text"] =
			$search: query
		fields.score = {$meta: "textScore"}

	mod =
		fields: fields
		limit: size
		skip: size*page

	if query
		mod.sort =
			score:
				$meta: "textScore"

	crs = Challenges.find filter, mod

	log_publication "Challenges", crs, filter,
			_challenge_fields, "challenges", user_id
	return crs


#######################################################
Meteor.publish "my_challenges", () ->
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
			entry["author_avatar"] = _get_avatar profile

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
				r["peer_avatar"] = _get_avatar profile

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


#######################################################
# solutions
#######################################################

#######################################################
Meteor.publish "my_solutions", () ->
	user_id = this.userId
	restrict =
		owner_id: user_id

	filter = visible_items user_id, restrict
	crs = Solutions.find filter, _solution_fields

	log_publication "Solutions", crs, filter,
			_challenge_fields, "my_solutions", user_id
	return crs

#######################################################
Meteor.publish "solution_by_id", (solution_id) ->
	check solution_id, String
	user_id = this.userId

	if !user_id
		throw new Meteor.Error("Not permitted.")

	#TODO: only user that are eligible should see this.

	filter =
		_id: solution_id
		published: true

	crs = Solutions.find filter, _solution_fields

	log_publication "Solutions", crs, filter,
			_challenge_fields, "solution_by_id", user_id
	return crs


#######################################################
Meteor.publish "my_solution_by_id", (solution_id) ->
	check solution_id, String
	user_id = this.userId

	restrict =
		_id: solution_id
		owner_id: user_id

	filter = visible_items user_id, restrict
	crs = Solutions.find filter, _solution_fields

	log_publication "Solutions", crs, filter,
			_challenge_fields, "my_solution_by_id", user_id
	return crs


#######################################################
Meteor.publish "my_solutions_by_challenge_id", (challenge_id) ->
	check challenge_id, String
	user_id = this.userId

	restrict =
		owner_id: user_id
		challenge_id: challenge_id

	filter = visible_items user_id, restrict
	crs = Solutions.find filter, _solution_fields

	log_publication "Solutions", crs, filter,
			_challenge_fields, "my_solutions_by_challenge_id", user_id
	return crs


#######################################################
Meteor.publish "solutions_for_tutors", (challenge_id) ->
	self = this
	user_id = this.userId

	if not Roles.userIsInRole user_id, "tutor"
		console.log "dafuck"
		throw new Meteor.Error("Not permitted.")


	gen_tut = (id) ->
		rr = ReviewRequests.findOne id
		solution = Solutions.findOne rr.solution_id
		date = rr.under_review_since
		now = new Date()
		difference = now - date
		item =
			solution_id: rr.solution_id
			content: solution.content
			material: solution.material
			date: date
			wait: how_much_time difference

		return item

	filter =
		challenge_id: challenge_id
		owner_id:
			$ne: user_id
		review_done: false

	mod =
		sort:
			under_review_since: 1

	handler = ReviewRequests.find(filter, mod).observeChanges
		added: (id, fields) ->
			credit = gen_tut id
			self.added("tutor_solutions", id, credit)

		changed: (id, fields) ->
			credit = gen_credit id
			self.changed("tutor_solutions", id, credit)

		removed: (id) ->
      self.removed("tutor_solutions", id)

	self.ready()
	self.onStop ->
    handler.stop()


#######################################################
# reviews
#######################################################

#######################################################
Meteor.publish "my_reviews", () ->
	user_id = this.userId
	restrict =
		owner_id: user_id

	filter = visible_items user_id, restrict
	crs = Reviews.find filter, _review_fields

	log_publication "Reviews", crs, filter,
			_challenge_fields, "my_reviews", user_id
	return crs


#######################################################
Meteor.publish "my_review_by_id", (review_id) ->
	check review_id, String
	user_id = this.userId

	restrict =
		_id: review_id
		owner_id: user_id

	filter = visible_items user_id, restrict
	crs = Reviews.find filter, _review_fields

	log_publication "Reviews", crs, filter,
			_challenge_fields, "my_review_by_id", user_id
	return crs


#######################################################
Meteor.publish "reviews_by_solution_id", (solution_id) ->
	check solution_id, String
	user_id = this.userId

	filter =
		solution_id: solution_id
		published: true

	crs = Reviews.find filter, _review_fields

	log_publication "Reviews", crs, filter,
			_challenge_fields, "reviews_by_solution_id", user_id
	return crs


#######################################################
# feedback
#######################################################

#######################################################
Meteor.publish "my_feedback_by_review_id", (review_id) ->
	check review_id, String
	user_id = this.userId

	filter =
		parent_id: review_id
		owner_id: user_id
	crs = Feedback.find filter, _feedback_fields

	log_publication "Feedback", crs, filter,
			_challenge_fields, "my_feedback_by_review_id", user_id
	return crs


#######################################################
Meteor.publish "feedback_by_review_id", (review_id) ->
	check review_id, String
	user_id = this.userId

	filter =
		review_id: review_id
		provider_id: user_id

	request = ReviewRequests.findOne filter
	crs = Feedback.find request.feedback_id, _feedback_fields

	log_publication "Feedback", crs, filter,
			_challenge_fields, "feedback_by_review_id", user_id
	return crs


#######################################################
# Resumes
#######################################################

#######################################################
Meteor.publish "user_credentials", (user_id) ->
	check user_id, String

	if !user_id
		user_id = this.userId

	filter =
		_id: user_id

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
			resume.avatar = _get_avatar profile

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
					solution.challenge_owner_avatar = _get_avatar profile

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
						review.avatar = _get_avatar profile

				review.review = r.content
				solution.reviews.push(review)

			if abs_rating
				avg = Math.round(abs_rating / num_ratings, 1)
				solution.average = avg

			solution_list.push(solution)

		resume.solutions = solution_list
		self.added("user_credentials", user._id, resume)

	crs = Meteor.users.find(filter)
	crs.forEach(prepare_resume)

	log_publication "UserCredentials", crs, filter,
			_challenge_fields, "credits", user_id
	self.ready()

#######################################################
# credits
#######################################################

#######################################################
Meteor.publish "credits", () ->
	user_id = this.userId
	self = this
	filter =
		$or:[
			{requester_id: user_id}
			{provider_id: user_id}]

	gen_credit = (id) ->
		obj = ReviewRequests.findOne id
		review_value = 0
		feedback_value = 0
		review_time = -1
		feedback_time = -1

		if obj.requester_id == user_id
			review_value -= 1
			feedback_value += if obj.feedback_done then 1 else 0
			if obj.feedback_finished
				feedback_time = obj.feedback_finished-obj.review_finished
		if obj.provider_id == user_id
			feedback_value -= 1
			review_value += if obj.review_done then 1 else 0
			if obj.review_finished
				review_time = obj.review_finished-obj.under_review_since

		credit =
			_id: id
			review_time: review_time
			review_value: review_value
			feedback_time: feedback_time
			feedback_value: feedback_value
			solution_id: obj.solution_id
			challenge_id: obj.challenge_id
		return credit

	handler = ReviewRequests.find(filter).observeChanges
		added: (id, fields) ->
			credit = gen_credit id
			self.added("user_credits", id, credit)

		changed: (id, fields) ->
			credit = gen_credit id
			self.changed("user_credits", id, credit)

		removed: (id) ->
      self.removed("user_credits", id)

	self.ready()
	self.onStop ->
    handler.stop()