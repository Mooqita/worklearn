###############################################
@gen_feedback = (solution, review, user) ->
	filter =
		review_id: review._id

	feedback = Feedback.findOne filter
	if feedback
		return feedback._id

	if solution._id != review.solution_id
		msg = "solution._id: " + solution._id
		msg += " differs from review.solution_id :" + review.solution_id
		log_event msg, event_create, event_crit
		throw new Meteor.Error msg

	feedback =
		review_id: review._id
		solution_id: solution._id
		challenge_id: solution.challenge_id
		requested: new Date()
		assigned: false
		published: false

	feedback_id = store_document_unprotected Feedback, feedback, user, true
	return feedback_id


###############################################
@finish_feedback = (feedback, user) ->
	if not feedback.rating
		throw new Meteor.Error "Feedback: " + feedback._id + " Does not have a rating."

	if feedback.published
		throw new Meteor.Error "Feedback: " + feedback._id + " is already published."

	owner_id = get_document_owner "reviews", feedback.review_id
	modify_field_unprotected Feedback, feedback._id, "published", true
	modify_field_unprotected Feedback, feedback._id, "requester_id", owner_id

	feedback = Feedback.findOne feedback._id
	send_feedback_message feedback

	msg = "Feedback (" + feedback._id + ") feedback finished by: " + get_user_mail user
	log_event msg, event_logic, event_info

	return feedback._id


###############################################
@repair_feedback = (solution, review, user) ->
	filter =
		solution_id: solution._id
		review_id: review._id
	feedback = Feedback.findOne filter

	if feedback
		return feedback._id

	return gen_feedback solution, review, user


###############################################
@reopen_feedback = (feedback, user) ->
	if !feedback.published
		return feedback._id

	modify_field_unprotected Feedback, feedback._id, "published", false

	msg = "Feedback (" + review.id + ") reopened by: " + get_user_mail user
	log_event msg, event_logic, event_info

	return feedback._id





