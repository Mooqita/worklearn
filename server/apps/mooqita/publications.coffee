#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
Meteor.publish "peers_by_challenge", (challenge_id, page=0, size=10) ->
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
		visible_to: "anonymous"

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

		author = Meteor.users.findOne(entry.owner_id)
		profile = 	profile = Responses.findOne(filter)

		entry['author_id'] = author._id
		entry['author_name'] = profile.given_name + ' ' + profile.family_name
		entry['author_avatar'] = profile.avatar

		filter =
			parent_id: entry._id
			visible_to: "anonymous"

		options =
			fields:
				rating: 1
				content: 1
				owner_id: 1

		reviews = Responses.find(filter, options).fetch()

		for o in reviews
			filter =
				owner_id: o.owner_id
				type_identifier: "profile"

			peer = Meteor.users.findOne(o.owner_id)
			profile = profile = Responses.findOne(filter)
			o['peer_id'] = peer._id
			o['peer_name'] = profile.given_name + ' ' + profile.family_name
			o['peer_avatar'] = profile.avatar

		avg = (r.rating for r in reviews).reduce (t, s) -> t + s
		entry['reviews'] = reviews
		entry["average_rating"] = if avg then avg else reviews[0].rating

		self.added('peers', entry._id, entry)

	Responses.find(filter, options).forEach(add_info)
	self.ready()


#######################################################
# Resumes
#######################################################

#######################################################
Meteor.publish "resume_by_user", (user_id) ->
	check user_id, String
	if !user_id
		user_id = this.userId

	filter =
		_id: user_id

	self = this
	prepare_resume = (user) ->
		profile = Responses.findOne user._id
		resume = {}
		resume.name = profile.given_name
		resume.owner_id = user._id
		resume.avatar = profile.avatar
		resume.self_description = profile.resume

		sub_filter =
			visible_to: "anonymous"
			owner_id: user._id
			#in_portfolio: true

		subs = []
		solutions = Responses.find sub_filter
		solutions.forEach (s) ->
			sub = {}
			sub.reviews = []
			sub.solution = if !s.confidential then s.content else null

			challenge = Responses.findOne(s.challenge_id)
			if challenge
				sub.challenge = if !challenge.confidential then challenge.content else null
				sub.challenge_title = challenge.title

				challenge_owner = Meteor.users.findOne(challenge.owner_id)
				sub.challenge_owner_id = challenge.owner_id
				sub.challenge_owner_avatar = challenge_owner.profile.avatar

			t = 0
			n = 0
			rev_filter =
				solution_id:s._id
			reviews = Responses.find(rev_filter)
			reviews.forEach (r) ->
				rev = {}
				u = Meteor.users.findOne(r.owner_id)
				rev.review = r.content
				rev.grade = r.grade
				rev.name = u.profile.given_name
				rev.avatar = u.profile.avatar
				rev.owner_id = r.owner_id

				sub.reviews.push(rev)
				t += r.grade
				n += 1

			sub.average = Math.round(t/n, 1)
			subs.push(sub)

		resume.solutions = subs
		self.added('resumes', user._id, resume)

	Meteor.users.find(filter).forEach(prepare_resume)
	self.ready()


#######################################################
Meteor.publish 'find_upwork_work', (q, paging, budget) ->
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
			self.added('tasks', Random.id(), error)
			console.log(error)
		else
			for d in data.jobs
				if Tasks.findOne(d.id)
					continue
				d.snippet = d.snippet.split('\n').join('<br>')
				self.added('tasks', d.id, d)

	bound = Meteor.bindEnvironment(remote)
	jobs.find params, bound

	self.ready()

