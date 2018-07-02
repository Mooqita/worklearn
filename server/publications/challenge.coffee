###############################################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
###############################################################################

###############################################################################
# item header
###############################################################################

###############################################################################
_challenge_fields =
	published: 1
	# client
	link: 1
	title: 1
	origin: 1
	job_ids: 1
	content: 1
	created: 1
	material: 1
	concepts: 1
	num_reviews: 1
	self_service: 1
	self_service_help: 1
	no_solution_notification: 1
	# client to designer
	role: 1
	idea: 1
	team: 1
	social: 1
	process: 1
	strategic: 1
	contributor: 1
	description: 1
	# system set TODO: should not be in here
	promo: 1
	pined: 1
	requested: 1
	discoverable: 1

###############################################################################
# challenges
###############################################################################

###############################################################################
Meteor.publish "challenges", (parameter) ->
	pattern =
		admissions: Match.Optional(admission_list)
		sort_by: Match.Optional(String)
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
	filter =
		published: true
		discoverable: true

	mod =
		fields: _challenge_fields

	crs = get_documents_paged_unprotected Challenges, filter, mod, parameter
	log_publication crs, user_id, "challenges"

	return crs


###############################################################################
Meteor.publish "published_challenge_by_id", (challenge_id) ->
	check challenge_id, String

	user_id = this.userId

	filter =
		_id: challenge_id
		published: true

	mod =
		fields: _challenge_fields

	crs = Challenges.find filter, mod
	log_publication crs, user_id, "published_challenge_by_id"

	return crs


###############################################################################
Meteor.publish "my_challenges", (parameter) ->
	pattern =
		admissions: Match.Optional(admission_list)
		sort_by: Match.Optional(String)
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter = get_my_filter Challenges, {}
	mod =
		fields: _challenge_fields

	crs = get_documents_paged_unprotected Challenges, filter, mod, parameter
	log_publication crs, user_id, "my_challenges"

	return crs


###############################################################################
Meteor.publish "my_challenge_by_id", (challenge_id) ->
	check challenge_id, String

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter = get_my_filter Challenges, {_id: challenge_id}
	mod =
		fields: _challenge_fields

	crs = Challenges.find filter, mod
	log_publication crs, user_id, "my_challenge_by_id"

	return crs


###############################################################################
Meteor.publish "challenges_by_admissions", (admissions) ->
	check admissions, admission_list

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	ids = []
	for admission in admissions
		ids.push(admission.i)

	filter =
		_id:
			$in: ids

	mod =
		fields: _challenge_fields

	crs = get_documents IGNORE, IGNORE, Challenges, filter, mod
	log_publication crs, user_id, "challenges_by_admissions"

	return crs


###############################################################################
Meteor.publish "challenges_by_ids", (challenge_ids) ->
	if challenge_ids and Array.isArray(challenge_ids) and challenge_ids.length > 0
		check(challenge_ids,[String])
	else
		return []

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter =
		_id:
			$in: challenge_ids

	mod =
		fields: _challenge_fields

	crs = Challenges.find filter, mod
	log_publication crs, user_id, "challenges_by_ids"

	return crs

###############################################################################
Meteor.publish "challenge_summaries", (parameter) ->
	pattern =
		challenge_id: String
		published: Match.Optional(Boolean)
		sort_by: Match.Optional(String)
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	if parameter.size>50
		throw Meteor.Error("Size values larger than 50 are not allowed.")

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	if not can_view Challenges, parameter.challenge_id, user_id
		throw Meteor.Error("Not permitted.")

	filter =
		challenge_id: parameter.challenge_id

	if parameter.published
		filter.published = parameter.published

	mod =
		fields:
			content: 1
			created: 1
			modified: 1
			material: 1
			published: 1
			challenge_id: 1

	resource_ids = new Set()
	user_ids = new Set()

	##############################################
	# retrieving solutions
	##############################################

	##############################################
	solution_cursor = get_documents_paged_unprotected Solutions, filter, mod, parameter
	solution_cursor.forEach (solution) ->
		resource_ids.add solution._id

	##############################################
	# retrieving reviews
	##############################################

	# resetting the filter
	solution_ids = Array.from(resource_ids)
	filter =
		solution_id:
			$in: solution_ids

	mod =
		fields:
			rating: 1
			content: 1
			published: 1
			challenge_id: 1
			solution_id: 1
			review_id: 1

	##############################################
	review_cursor = Reviews.find(filter, mod)
	review_cursor.forEach (entry) ->
		resource_ids.add entry._id

	##############################################
	# retrieving feedback
	##############################################

	##############################################
	feedback_cursor = Feedback.find(filter, mod)
	feedback_cursor.forEach (entry) ->
		resource_ids.add entry._id

	##############################################
	# retrieving admissions
	##############################################

	# resetting the filter
	r_ids = Array.from(resource_ids)
	filter =
		i:
			$in: r_ids

	admission_cursor = Admissions.find(filter)
	admission_cursor.forEach (entry) ->
		user_ids.add(entry.u)

	##############################################
	# retrieving profiles
	##############################################

	# resetting the filter
	user_ids = Array.from(user_ids)
	filter =
		user_id:
			$in: user_ids

	mod =
		fields:
			avatar: 1
			resume: 1
			user_id: 1
			published: 1
			given_name: 1
			middle_name: 1
			family_name: 1

	profile_cursor = Profiles.find(filter, mod)

	result = [solution_cursor, review_cursor, feedback_cursor, profile_cursor, admission_cursor]
	log_publication result, user_id, "challenge_summaries"

	return result

