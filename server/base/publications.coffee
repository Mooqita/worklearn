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
Meteor.publish "templates", (origin="") ->
	if origin is undefined
		console.log "Origin missing"
	check origin, String


	user_id = this.userId

	filter = visible_items user_id
	mod = visible_fields "Templates", null, user_id
	crs = Templates.find(filter, mod)

	console.log("Templates: " + crs.count() + " submitted!")
	return crs

#######################################################
Meteor.publish "template_by_id", (template_id, origin="") ->
	if origin is undefined
		console.log "template: origin missing"
	check origin, String

	if not template_id
		console.log "template: template_id missing: " + origin
	check template_id, String

	restrict =
		_id : template_id

	filter = visible_items this.userId, restrict
	mod = visible_fields "Templates", template_id, this.userId
	crs = Templates.find(filter, mod)

	console.log("Template loaded: " + crs.count() + " submitted!")
	return crs


#######################################################
# responses
#######################################################

#######################################################
Meteor.publish "responses", (filter, origin) ->
	#console.log "Origin " + origin

	if origin is undefined
		console.log "responses: origin missing"
	check origin, String

	user_id = this.userId

	restrict = make_filter_save user_id, filter
	filter = visible_items user_id, restrict
	fields = visible_fields "Responses", user_id, filter
	crs = Responses.find filter, fields

	log_publication crs, filter, fields, origin
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
	if not item_id
		return []
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

