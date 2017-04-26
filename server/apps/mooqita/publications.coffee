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
		type_identifier: 1

#######################################################
_solution_fields =
	fields:
		content: 1
		owner_id: 1
		published: 1
		parent_id: 1
		challenge_id: 1
		type_identifier: 1

#######################################################
_review_fields =
	fields:
		rating: 1
		content: 1
		published: 1
		parent_id: 1
		solution_id: 1
		challenge_id: 1
		type_identifier: 1

#######################################################
_feedback_fields =
	fields:
		rating: 1
		content: 1
		parent_id: 1
		published: 1
		solution_id: 1
		challenge_id: 1
		type_identifier: 1


#######################################################
_get_avatar = (profile) ->
	avatar = ""

	if profile.avatar
		if profile.avatar.length <= 32
			file = download_file_unprotected "Responses", profile._id, "avatar"
			avatar = file.data
		else
			avatar = profile.avatar


#######################################################
# challenges
#######################################################

#######################################################
Meteor.publish "challenges", () ->
	restrict =
		type_identifier: "challenge"

	filter = visible_items this.userId, restrict

	return Responses.find filter, _challenge_fields


#######################################################
Meteor.publish "my_challenges", () ->
	restrict =
		owner_id: this.userId
		type_identifier: "challenge"

	filter = visible_items this.userId, restrict

	return Responses.find filter, _challenge_fields


#######################################################
Meteor.publish "challenge_by_id", (challenge_id) ->
	check challenge_id, String

	restrict =
		_id:challenge_id

	filter = visible_items this.userId, restrict

	return Responses.find filter, _challenge_fields


#######################################################
Meteor.publish "my_challenge_by_id", (challenge_id) ->
	restrict =
		_id:challenge_id
		owner_id: this.userId

	filter = visible_items this.userId, restrict

	return Responses.find filter, _challenge_fields


#######################################################
Meteor.publish "challenge_summary", (challenge_id, page=0, size=10) ->
	check challenge_id, String
	check page, Number
	check size, Number

	if size>10
		throw Meteor.Error('Size values larger than 10 are not allowed.')

	self = this
	filter =
		owner_id: this.userId
		type_identifier: "profile"

	user = Meteor.users.findOne(this.userId)
	profile = Responses.findOne(filter)
	challenge = Responses.findOne(challenge_id)

	if challenge.owner_id != user._id
		return []

	filter =
		parent_id: challenge_id
		type_identifier: "solution"
		published: true

	options =
		fields:
			content: 1
			reviews: 1
			owner_id: 1
			challenge_id: 1
			reviews_required: 1
		skip: page * size
		limit: size

	add_info = (entry) ->
		filter =
			owner_id: entry.owner_id
			type_identifier: "profile"

		author = Meteor.users.findOne entry.owner_id
		profile = Responses.findOne filter

		entry['author_id'] = author._id
		entry['author_name'] = profile.given_name + ' ' + profile.family_name
		entry['author_avatar'] = _get_avatar profile

		filter =
			parent_id: entry._id
			visible_to: "anonymous"

		options =
			fields:
				rating: 1
				content: 1
				owner_id: 1

		reviews = Responses.find(filter, options).fetch()
		avg = 0
		nt = 0

		for o in reviews
			filter =
				owner_id: o.owner_id
				type_identifier: "profile"

			peer = Meteor.users.findOne(o.owner_id)
			profile = profile = Responses.findOne(filter)

			o['peer_id'] = peer._id
			o['peer_name'] = profile.given_name + ' ' + profile.family_name
			o['peer_avatar'] = _get_avatar profile
			avg += r.rating
			nt += 1

		avg = if nt then avg / nt else "no reviews yet"
		entry['reviews'] = reviews
		entry["average_rating"] = avg

		self.added('challenge_summary', entry._id, entry)

	Responses.find(filter, options).forEach(add_info)
	self.ready()


#######################################################
# solutions
#######################################################

#######################################################
Meteor.publish "my_solutions", () ->
	restrict =
		owner_id: this.userId
		type_identifier: "solution"

	filter = visible_items this.userId, restrict

	return Responses.find filter, _solution_fields


#######################################################
Meteor.publish "solution_by_id", (solution_id) ->
	check solution_id, String

	if !this.userId
		throw new Meteor.Error("Not permitted.")

	#TODO: only user that are eligible should see this.

	filter =
		_id: solution_id
		published: true

	return Responses.find filter, _solution_fields


#######################################################
Meteor.publish "my_solution_by_id", (solution_id) ->
	check solution_id, String

	restrict =
		_id: solution_id
		owner_id: this.userId

	filter = visible_items this.userId, restrict
	return Responses.find filter, _solution_fields


#######################################################
Meteor.publish "my_solutions_by_challenge_id", (challenge_id) ->
	check challenge_id, String

	restrict =
		owner_id: this.userId
		challenge_id: challenge_id
		type_identifier: "solution"

	filter = visible_items this.userId, restrict
	return Responses.find filter, _solution_fields

#######################################################
# reviews
#######################################################

#######################################################
Meteor.publish "my_reviews", () ->
	restrict =
		owner_id: this.userId
		type_identifier: "review"

	filter = visible_items this.userId, restrict

	return Responses.find filter, _review_fields

#######################################################
Meteor.publish "my_review_by_id", (review_id) ->
	check review_id, String

	restrict =
		_id: review_id
		owner_id: this.userId
		type_identifier: "review"

	filter = visible_items this.userId, restrict

	return Responses.find filter, _review_fields

#######################################################
Meteor.publish "reviews_by_solution_id", (solution_id) ->
	check solution_id, String

	filter =
		solution_id: solution_id
		type_identifier: "review"
		published: true

	return Responses.find filter, _review_fields


#######################################################
# feedback
#######################################################

#######################################################
Meteor.publish "my_feedback_by_review_id", (review_id) ->
	check review_id, String

	filter =
		type_identifier: "feedback"
		parent_id: review_id
		owner_id: this.userId

	return Responses.find filter, _feedback_fields


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
			type_identifier: "profile"

		user_profile = Responses.findOne filter

		if user_profile
			resume.name = user_profile.given_name
			resume.owner_id = user_profile._id
			resume.self_description = user_profile.resume
			resume.avatar = _get_avatar user_profile

		solution_filter =
			type_identifier: "solution"
			published: true
			owner_id: user._id
			#in_portfolio: true

		solution_list = []
		solution_cursor = Responses.find solution_filter

		solution_cursor.forEach (s) ->
			solution = {}
			solution.reviews = []
			solution.solution = if !s.confidential then s.content else null

			challenge = Responses.findOne(s.challenge_id)
			if challenge
				solution.challenge = if !challenge.confidential then challenge.content else null
				solution.challenge_title = challenge.title

				filter =
					owner_id: challenge.owner_id
					type_identifier: "profile"
				challenge_owner_profile = Responses.findOne filter

				solution.challenge_owner_id = challenge.owner_id
				solution.challenge_owner_avatar = _get_avatar challenge_owner_profile

			t = 0
			n = 0

			review_filter =
				type_identifier: "review"
				solution_id: s._id
			review_cursor = Responses.find(review_filter)

			review_cursor.forEach (r) ->
				review = {}

				filter =
					owner_id: r.owner_id
					type_identifier: "profile"
				profile = Responses.findOne filter

				review.review = r.content
				review.rating = r.rating
				review.name = profile.given_name
				review.owner_id = r.owner_id
				review.avatar = _get_avatar profile

				solution.reviews.push(review)
				t += r.rating
				n += 1

			solution.average = Math.round(t/n, 1)
			solution_list.push(solution)

		resume.solutions = solution_list
		self.added('user_credentials', user._id, resume)

	Meteor.users.find(filter).forEach(prepare_resume)
	self.ready()


#######################################################
Meteor.publish 'find_upwork_work', (q, paging, budget) ->
	console.log "find_upwork_work"
	if not q
		q = ""

	if not paging
		paging = ""

	if not budget
		 budget = ""

	check q, String
	check paging, String
	check budget, String

	if not this.userId
		throw Meteor.Error(403, "Not authorized.")

	self = this
	secret = Secrets.findOne()
	config =
		consumerKey: secret.upwork.oauth.consumerKey
		consumerSecret: secret.upwork.oauth.consumerSecret

	UpworkApi = require('upwork-api')
	Search = require('upwork-api/lib/routers/jobs/search.js').Search

	api = new UpworkApi(config)
	jobs = new Search(api)
	params =
		q: q
		paging: paging
		budget: budget
		job_type: 'fixed'
	accessToken = secret.upwork.oauth.accessToken
	accessTokenSecret = secret.upwork.oauth.accessSecret

	api.setAccessToken accessToken, accessTokenSecret, () ->

	remote = (error, data) ->
		if error
			error.error = true
			self.added('upwork_tasks', Random.id(), error)
			console.log(error)
		else
			for d in data.jobs
				if UpworkTasks.findOne(d.id)
					continue
				d.snippet = d.snippet.split('\n').join('<br>')
				self.added('upwork_tasks', d.id, d)

	bound = Meteor.bindEnvironment(remote)
	jobs.find params, bound

	self.ready()

