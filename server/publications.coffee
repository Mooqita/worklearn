#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
Meteor.publish "templates", () ->
	filter = filter_visible_to_user this.userId

	mod =
		fields:
			_id : 1
			name: 1
			owner_id: 1

	crs = Templates.find(filter, mod)
	console.log("Templates: " + crs.count() + " submitted!")
	return crs

#######################################################
Meteor.publish "template_by_id", (template_id) ->
	check template_id, String

	restrict =
		_id : template_id

	filter = filter_visible_to_user this.userId, restrict

	crs = Templates.find(filter)
	console.log("Template loaded: " + crs.count() + " submitted!")
	return crs

#######################################################
Meteor.publish "responses", () ->
	filter = filter_visible_to_user this.userId

	mod =
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

	crs = Responses.find filter, mod
	console.log("Responses: " + crs.count() + " submitted!")
	return crs

#######################################################
Meteor.publish "responses_with_data", (post_group) ->
	restrict =
		post_group: post_group

	filter = filter_visible_to_user this.userId, restrict

	crs = Responses.find filter
	console.log("Responses: " + crs.count() + " submitted!")
	return crs

#######################################################
Meteor.publish "response", (template_id, index) ->
	check template_id, String
	check index, String

	restrict =
		template_id: template_id
		owner_id: this.userId
		index: index

	filter = filter_visible_to_user this.userId, restrict

	crs = Responses.find filter
	console.log("Responses: " + crs.count() + " submitted!")
	return crs

#######################################################
Meteor.publish "response_by_id", (response_id) ->
	check response_id, String

	restrict =
		_id: response_id

	filter = filter_visible_to_user this.userId, restrict

	crs = Responses.find filter
	console.log("Responses: " + crs.count() + " submitted!")
	return crs

#######################################################
Meteor.publish "sum_of_field", (template_id, field, value) ->
		console.log "sum_of_field"
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

