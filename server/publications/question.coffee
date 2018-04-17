#######################################################
# item header
#######################################################
_question_fields =
	fields:
		question: 1
		answer_one: 1
		answer_two: 1
		answer_three: 1
		answer_four: 1
		subject: 1
		correct_answer: 1
		owner_id: 1
		published: 1
		num_reviews: 1

#######################################################
# questions
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

	profile_ids = new Set()

	mod =
		fields:
			rating: 1
			content: 1
			owner_id: 1
			published: 1
			question_id: 1
			review_id: 1
			owner_id: 1

	##############################################
	# retrieving profiles
	##############################################
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

	profile_cursor = Profiles.find(filter, mod)

	log_publication "Multiple Cursor", null, {},
			{}, "question_summaries", user_id

	return [review_cursor, feedback_cursor, profile_cursor]
