###############################################################################
Meteor.publish "active_nlp_task", (task_id) ->
	check task_id, String

	user_id = this.userId
#	if !user_id
#		throw new Meteor.Error "Not permitted."

	crs = NLPTasks.find({_id: task_id}, {_id:1})

	log_publication crs, user_id, "active_nlp_task"
	return crs


#######################################################
Meteor.publish "my_matches", (parameter) ->
	pattern =
		query: Match.Optional(String)
		#collection_name: String
		item_id: String
		#field: String
		#in_collection: String
		#in_field: String
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
#	if not user_id
#		throw new Meteor.Error("Not permitted")

	filter =
		ids: parameter.item_id

	crs = Matches.find filter

	log_publication crs, user_id, "my_matches"
	return crs
