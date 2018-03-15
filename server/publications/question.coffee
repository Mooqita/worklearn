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
_question_fields =
	fields:
		title: 1
		content: 1
		material: 1
		owner_id: 1
		published: 1
		num_reviews: 1


#######################################################
# helper
#######################################################

#######################################################
_get_solution_data = (solution_id) ->
	solution = Solutions.findOne solution_id

	entry = _get_profile_data solution.owner_id, {}
	entry.content = solution.content
	entry.material = solution.material
	entry.published = solution.published

	entry = _get_reviews_data solution_id, entry

	return entry


#######################################################
_get_reviews_data = (solution_id, entry) ->
	filter =
		solution_id: solution_id
		published: true

	options =
		fields:
			rating: 1
			content: 1
			owner_id: 1

	review_cursor = Reviews.find filter, options
	reviews = []
	avg = 0
	nt = 0

	review_cursor.forEach (review) ->
		r = _get_profile_data review.owner_id, {}
		r = _get_feedback_data review._id, r
		r.content = review.content
		r.rating = review.rating

		reviews.push r
		avg += parseInt(r.rating)
		nt += 1

	avg = if nt then avg / nt else "no reviews yet"
	entry["reviews"] = reviews
	entry["average_rating"] = avg

	return entry


#######################################################
_get_feedback_data = (review_id, entry) ->
	filter =
		review_id: review_id
		published: true

	options =
		fields:
			rating: 1
			content: 1
			owner_id: 1

	feedback_cursor = Feedback.find filter, options
	feedback = []
	avg = 0
	nt = 0

	feedback_cursor.forEach (fdb) ->
		f = _get_profile_data fdb.owner_id, {}
		f.content = fdb.content
		f.rating = fdb.rating

		feedback.push f
		avg += parseInt(f.rating)
		nt += 1

	avg = if nt then avg / nt else "no reviews yet"
	entry["feedback"] = feedback
	entry["average_rating"] = avg

	return entry


#######################################################
_get_profile_data = (user_id, entry) ->
	filter =
		owner_id: user_id

	profile = Profiles.findOne filter
	if profile
		entry["name"] = get_profile_name profile, false, false
		entry["avatar"] = get_avatar profile

	return entry


#######################################################
# questions
#######################################################

#######################################################
Meteor.publish "questions", (parameter) ->
	pattern =
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
	filter = filter_visible_documents user_id

	crs = find_documents_paged_unprotected Questions, filter, _question_fields, parameter

	log_publication "Questions", crs, filter,
			_question_fields, "questions", user_id
	return crs


#######################################################
Meteor.publish "my_questions", (parameter) ->
	pattern =
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
	restrict =
		owner_id: user_id

	filter = filter_visible_documents user_id, restrict
	crs = find_documents_paged_unprotected Questions, filter, _question_fields, parameter

	log_publication "Questions", crs, filter,
			_question_fields, "my_questions", user_id
	return crs


#######################################################
Meteor.publish "question_by_id", (question_id) ->
	check question_id, String
	user_id = this.userId

	restrict =
		_id: question_id
		published: true

	filter = filter_visible_documents user_id, restrict
	crs = Questions.find filter, _question_fields

	log_publication "Questions", crs, filter,
			_question_fields, "question_by_id", user_id
	return crs


#######################################################
Meteor.publish "my_question_by_id", (question_id) ->
	user_id = this.userId

	restrict =
		_id:question_id
		owner_id: user_id

	filter = filter_visible_documents user_id, restrict
	crs = Questions.find filter, _question_fields

	log_publication "Questions", crs, filter,
			_question_fields, "my_question_by_id", user_id
	return crs


#######################################################
Meteor.publish "question_summaries", (parameter) ->
	pattern =
		question_id: String
		published: Match.Optional(Boolean)
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	if parameter.size>50
		throw Meteor.Error("Size values larger than 50 are not allowed.")

	user_id = this.userId
	question = Questions.findOne parameter.question_id

	if question.owner_id != user_id
		throw Meteor.Error("Not permitted.")

	filter =
		question_id: parameter.question_id

	if parameter.published
		filter.published = parameter.published

	mod =
		fields:
			content: 1
			material: 1
			owner_id: 1
			published: 1
			question_id: 1

	solution_ids = new Set()
	profile_ids = new Set()

	##############################################
	# retrieving solutions
	##############################################

	##############################################
	solution_cursor = find_documents_paged_unprotected Solutions, filter, mod, parameter
	solution_cursor.forEach (solution) ->
		solution_ids.add solution._id
		profile_ids.add solution.owner_id

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
			question_id: 1
			solution_id: 1
			review_id: 1
			owner_id: 1

	##############################################
	review_cursor = Reviews.find(filter, mod)
	review_cursor.forEach (entry) ->
		profile_ids.add entry.owner_id

	##############################################
	# retrieving feedback
	##############################################

	##############################################
	feedback_cursor = Feedback.find(filter, mod)
	feedback_cursor.forEach (entry) ->
		profile_ids.add entry.owner_id

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
			{}, "question_summaries", user_id

	return [solution_cursor, review_cursor, feedback_cursor, profile_cursor]
