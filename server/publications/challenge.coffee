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
		owner_id: 1
		published: 1
		num_reviews: 1


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

	filter = filter_visible_documents user_id
	crs = get_documents_paged_unprotected Challenges, filter, _challenge_fields, parameter

	log_publication "Challenges", crs, filter,
			_challenge_fields, "challenges", user_id

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

	restrict =
		owner_id: user_id

	filter = filter_visible_documents user_id, restrict
	crs = get_documents_paged_unprotected Challenges, filter, _challenge_fields, parameter

	log_publication "Challenges", crs, filter,
			_challenge_fields, "my_challenges", user_id
	return crs


#######################################################
Meteor.publish "challenge_by_id", (challenge_id) ->
	check challenge_id, String

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	restrict =
		_id: challenge_id
		published: true

	filter = filter_visible_documents user_id, restrict
	crs = Challenges.find filter, _challenge_fields

	log_publication "Challenges", crs, filter,
			_challenge_fields, "challenge_by_id", user_id
	return crs


#######################################################
Meteor.publish "my_challenge_by_id", (challenge_id) ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	restrict =
		_id:challenge_id
		owner_id: user_id

	filter = filter_visible_documents user_id, restrict
	crs = Challenges.find filter, _challenge_fields

	log_publication "Challenges", crs, filter,
			_challenge_fields, "my_challenge_by_id", user_id
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
			owner_id: 1
			published: 1
			challenge_id: 1

	solution_ids = new Set()
	profile_ids = new Set()

	##############################################
	# retrieving solutions
	##############################################

	##############################################
	solution_cursor = get_documents_paged_unprotected Solutions, filter, mod, parameter
	solution_cursor.forEach (solution) ->
		owner = get_document_owner Solutions, solution
		solution_ids.add solution._id
		profile_ids.add owner._id

	##############################################
	# retrieving reviews
	##############################################

	# resetting the filter
	solution_ids = Array.from(solution_ids)
	filter =
		solution_id:
			$in: solution_ids

	mod =
		fields:
			rating: 1
			content: 1
			owner_id: 1
			published: 1
			challenge_id: 1
			solution_id: 1
			review_id: 1
			owner_id: 1

	##############################################
	review_cursor = Reviews.find(filter, mod)
	review_cursor.forEach (entry) ->
		owner = get_document_owner Reviews, entry
		profile_ids.add owner._id

	##############################################
	# retrieving feedback
	##############################################

	##############################################
	feedback_cursor = Feedback.find(filter, mod)
	feedback_cursor.forEach (entry) ->
		owner = get_document_owner Feedback, entry
		profile_ids.add owner._id

	##############################################
	# retrieving profiles
	##############################################

	# resetting the filter
	profile_ids = Array.from(profile_ids)
	filter =
		owner_id:
			$in: profile_ids

	mod =
		fields:
			resume: 1
			published: 1
			given_name: 1
			middle_name: 1
			family_name: 1
			owner_id: 1
			avatar: 1

	##############################################
	profile_cursor = Profiles.find(filter, mod)

	log_publication "Multiple Cursor", null, {},
			{}, "challenge_summaries", user_id

	return [solution_cursor, review_cursor, feedback_cursor, profile_cursor]

