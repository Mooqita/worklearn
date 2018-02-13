#######################################################
Meteor.publish 'git_challenges', (parameter) ->
	pattern =
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	self = this

#	secret = Secrets.findOne()
#	config =
#		consumerKey: secret.upwork.oauth.consumerKey
#		consumerSecret: secret.upwork.oauth.consumerSecret

#	UpworkApi = require('upwork-api')
#	Search = require('upwork-api/lib/routers/jobs/search.js').Search

#	api = new UpworkApi(config)
#	jobs = new Search(api)
#	params =
#		q: q
#		paging: paging
#		budget: budget
#		job_type: 'fixed'
#	accessToken = secret.upwork.oauth.accessToken
#	accessTokenSecret = secret.upwork.oauth.accessSecret

#	api.setAccessToken accessToken, accessTokenSecret, () ->

#	remote = (error, data) ->
#		if error
#			console.log(error)
#		else
#			for d in data.jobs
#				if Tasks.findOne(d.id)
#					continue
#				d.snippet = d.snippet.split('\n').join('<br>')
#				self.added('tasks', d.id, d)

#	bound = Meteor.bindEnvironment(remote)
#	jobs.find params, bound

	self.added('git_challenges', 1, {title: "Connection to database works!"})
	self.ready()

