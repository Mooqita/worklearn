#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
# templates
#######################################################

#######################################################
Meteor.publish "templates", (header_only=true) ->
	check header_only, Boolean

	user_id = this.userId

	filter = visible_items user_id
	mod = visible_fields "Templates", null, user_id, header_only
	crs = Templates.find(filter, mod)

	console.log("Templates: " + crs.count() + " submitted!")
	return crs

#######################################################
Meteor.publish "template_by_id", (template_id, header_only=true) ->
	check template_id, String
	check header_only, Boolean

	restrict =
		_id : template_id

	filter = unsafe_filter_visible_to_user this.userId, restrict
	mod = unsafe_visible_fields "Templates", template_id, this.userId, header_only
	crs = Templates.find(filter, mod)

	console.log("Template loaded: " + crs.count() + " submitted!")
	return crs


#######################################################
# responses
#######################################################

#######################################################
_accepts =
	type_identifier: String
	challenge_id: String
	solution_id: String
	template_id: String
	group_name: String
	parent_id: String
	owner_id: String
	index: Match.OneOf String, Number
	text: String
	_id: String

#######################################################
_filter = (user_id, param) ->
	restrict = {}

	for p, t of _accepts
		if param[p]
			check param[p], t
			if p == "text"
				restrict["$text"] =
					$search: param[p]
			else
				restrict[p] = param[p]

	return restrict


#######################################################
_log_responses = (crs, filter, fields, mine, header_only, origin) ->

	f = JSON.stringify(filter, null, 2);
	m = JSON.stringify(fields, null, 2);

	data = if header_only then "without data" else "with data"

	console.log "Submitted " + crs.count() + " responses " + data + " to " + origin
	console.log f
#	console.log "With fields"
#	console.log m

#######################################################
Meteor.publish "responses", (filter, mine, header_only, origin) ->
	check mine, Boolean
	check header_only, Boolean
	check origin, String

	user_id = this.userId

	restrict = _filter user_id, filter
	filter = visible_items user_id, mine, restrict
	fields = visible_fields "Responses", user_id, mine, header_only
	crs = Responses.find filter, fields

	_log_responses crs, filter, fields, mine, header_only, origin
	return crs

#######################################################
# summaries
#######################################################

#######################################################
Meteor.publish "sum_of_field", (template_id, field, value) ->
	check template_id, String
	check field, String
	check value, String

	filter = {}
	filter[field] = value

	self = this;
	count = 0;
	initializing = true;

	handlers =
		added: (id) ->
			count++;
			if (!initializing)
				self.changed "summaries", value, {label:value, count: count}

		removed: (id) ->
			count--
			self.changed "summaries", value, {label:value, count: count}

	handle = Responses.find(filter).observe handlers

	initializing = false;
	self.added("summaries", value, {label:value, count: count});
	self.ready()
	self.onStop () ->
		handle.stop()


#######################################################
# special
#######################################################

#######################################################
Meteor.publish "files", (collection_name, item_id, field) ->
	check collection_name, String
	check item_id, String
	check field, String

	fields = visible_fields(collection_name, item_id, this.userId)

	if field not in fields
		throw new Meteor.Error "Not enough rights"

	colllection = get_collection collection_name
	data =
		data: colllection.findOne(item_id)[field]

	this.added("files", Random.id(), data)
	console.log("File: "+collection_name+"."+field+" submitted!")

#######################################################
Meteor.publish "permissions", () ->
	if !this.userId
		throw new Meteor.Error("Not permitted.")

	if !Roles.userIsInRole(this.userId, "admin")
		throw new Meteor.Error("Not permitted.")

	crs = Permissions.find()
	console.log("Permissions: " + crs.count() + " submitted!")
	return crs

#######################################################
Meteor.publish 'find_upwork_work', (q, paging, budget) ->
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

