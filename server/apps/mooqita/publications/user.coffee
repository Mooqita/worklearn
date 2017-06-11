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

	crs = Meteor.users.find(filter)
	crs.forEach(prepare_resume)

	log_publication "UserCredentials", crs, filter, {}, "credits", user_id
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