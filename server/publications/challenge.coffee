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
		published: 1
		num_reviews: 1
		link: 1
		origin: 1
		job_ids: 1

#######################################################
# challenges
#######################################################

#######################################################
Meteor.publish "challenges", (parameter) ->
	pattern =
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter =
		published: true

	crs = get_documents_paged_unprotected Challenges, filter, _challenge_fields, parameter

	log_publication crs, user_id, "challenges"
	return crs


#######################################################
Meteor.publish "my_challenges", (parameter) ->
	pattern =
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter = get_my_filter Challenges, {}
	crs = get_documents_paged_unprotected Challenges, filter, _challenge_fields, parameter

	log_publication crs, user_id, "my_challenges"
	return crs


#######################################################
Meteor.publish "challenge_by_id", (challenge_id) ->
	check challenge_id, String

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter =
		_id: challenge_id
		published: true

	crs = Challenges.find filter, _challenge_fields
	log_publication crs, user_id, "challenge_by_id"

	return crs


#######################################################
Meteor.publish "challenges_by_admissions", (admissions) ->
	param =
		_id: String
		c: String
		u: String
		i: String
		r: String
	check admissions, [param]

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	ids = []
	for admission in admissions
		ids.push(admission.i)

	filter =
		_id:
			$in: ids

	crs = get_documents IGNORE, IGNORE, Challenges, filter, _challenge_fields
	log_publication crs, user_id, "challenges_by_admissions"
	return crs


#######################################################
Meteor.publish "my_challenge_by_id", (challenge_id) ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	filter = get_my_filter Challenges, {_id:challenge_id}
	crs = Challenges.find filter, _challenge_fields

	log_publication crs, user_id, "my_challenge_by_id"
	return crs

#######################################################
Meteor.publish "challenges_by_ids", (challenge_ids) ->
	if challenge_ids and Array.isArray(challenge_ids) and challenge_ids.length > 0
		check(challenge_ids,[String])
	else
		return []

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	sub_filter =
		_id:
			$in: challenge_ids

	# TODO: improve get_my_filter to handle multiple ids.
	#filter = get_my_filter Challenges, {sub_filter}
	crs = Challenges.find sub_filter, _challenge_fields

	log_publication crs, user_id, "challenges_by_ids"
	return crs

#######################################################
Meteor.publish "challenge_summaries", (parameter) ->
	pattern =
		challenge_id: String
		published: Match.Optional(Boolean)
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
		resource_id:
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

