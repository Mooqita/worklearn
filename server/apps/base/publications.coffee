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
		log_event "origin missing", event_pub, event_warn
	check origin, String


	user_id = this.userId

	filter = visible_items user_id
	mod = visible_fields "Templates", null, user_id
	crs = Templates.find(filter, mod)

	log_publication "Templates", crs, filter, mod, origin, user_id
	return crs

#######################################################
Meteor.publish "template_by_id", (template_id, origin="") ->
	if origin is undefined
		log_event "origin missing", event_pub, event_warn,
	check origin, String

	if not template_id
		log_event "template_id missing: " + origin
		log_event msg, event_pub, event_err
		return []
	check template_id, String

	restrict =
		_id : template_id

	filter = visible_items this.userId, restrict
	mod = visible_fields "Templates", template_id, this.userId
	crs = Templates.find(filter, mod)

	log_publication "Templates", crs, filter, mod, origin, user_id
	return crs


#######################################################
# responses
#######################################################

#######################################################
Meteor.publish "responses", (collection_name, filter, origin) ->
	collection = get_collection_save collection_name

	if origin is undefined
		log_event "Origin missing for function responses", event_pub, event_warn
	check origin, String

	user_id = this.userId

	restrict = make_filter_save user_id, filter
	filter = visible_items user_id, restrict
	fields = visible_fields collection, user_id, filter
	crs = collection.find filter, fields

	log_publication collection_name, crs, filter, fields, origin, user_id
	return crs

#######################################################
# summaries
#######################################################

#######################################################
Meteor.publish "sum_of_field", (collection_name, field, value) ->
	collection = get_collection_save collection_name

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

	handle = collection.find(filter).observe handlers

	initializing = false;
	self.added("summaries", value, {label:value, count: count});
	self.ready()
	self.onStop () ->
		handle.stop()


#######################################################
Meteor.publish "permissions", () ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	if !Roles.userIsInRole user_id, "admin"
		throw new Meteor.Error "Not permitted."

	crs = Permissions.find()
	log_publication "Permissions", crs, {}, {}, "permissions", user_id
	return crs

