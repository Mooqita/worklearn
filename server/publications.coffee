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
_template_header =
	fields:
		_id : 1
		name: 1
		owner_id: 1

#######################################################
Meteor.publish "templates", (header_only=true) ->
	filter = filter_visible_to_user this.userId
	mod = if header_only then _template_header else {}
	crs = Templates.find(filter, mod)

	console.log("Templates: " + crs.count() + " submitted!")
	return crs

#######################################################
Meteor.publish "template_by_id", (template_id, header_only=true) ->
	check template_id, String

	restrict =
		_id : template_id

	filter = filter_visible_to_user this.userId, restrict
	mod = if header_only then _template_header else {}
	crs = Templates.find(filter, mod)

	console.log("Template loaded: " + crs.count() + " submitted!")
	return crs


#######################################################
# responses
#######################################################

#######################################################
_response_header =
	fields:
		_id : 1
		name: 1
		index: 1
		title: 1
		deleted: 1
		owner_id: 1
		parent_id: 1
		visible_to: 1
		group_name: 1
		view_order: 1
		template_id: 1

#######################################################
Meteor.publish "responses", (header_only=true) ->
	filter = filter_visible_to_user this.userId
	mod = if header_only then _response_header else {}

	crs = Responses.find filter, mod
	console.log "Responses " + if header_only then "" else " with data" +
					": " + crs.count() + " submitted!"

	return crs

#######################################################
Meteor.publish "responses_by_group", (group_name, header_only=false) ->
	restrict =
		group_name: group_name

	filter = filter_visible_to_user this.userId, restrict
	mod = if header_only then _response_header else {}
	crs = Responses.find filter, mod

	console.log "Responses by group: " + group_name + " " +
					if header_only then "" else "with data" +
					": " + crs.count() + " submitted!"
	return crs

#######################################################
Meteor.publish "response_by_id", (response_id, header_only=false) ->
	check response_id, String

	restrict =
		_id: response_id

	filter = filter_visible_to_user this.userId, restrict
	mod = if header_only then _response_header else {}
	crs = Responses.find filter, mod

	console.log "Responses by id: " + response_id + " " +
					if header_only then "" else "with data" +
					": " + crs.count() + " submitted!"
	return crs


#######################################################
Meteor.publish "responses_by_parent", (parent_id, header_only=false) ->
	check parent_id, String

	restrict =
		parent_id: parent_id

	filter = filter_visible_to_user this.userId, restrict
	mod = if header_only then _response_header else {}
	crs = Responses.find filter, mod

	console.log "Responses by parent_id: " + parent_id + " " +
					if header_only then "" else "with data" +
					": " + crs.count() + " submitted!"
	return crs


#######################################################
Meteor.publish "response_by_template", (template_id, index, header_only=false) ->
	check template_id, String
	check index, String

	restrict =
		template_id: template_id
		owner_id: this.userId
		index: index

	filter = filter_visible_to_user this.userId, restrict
	mod = if header_only then _response_header else {}
	crs = Responses.find filter, mod

	console.log "Responses by template_id: " + template_id + " " +
					if header_only then "" else "with data" +
					": " + crs.count() + " submitted!"
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
	field_visible(collection_name, item_id, field, this.userId)

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

