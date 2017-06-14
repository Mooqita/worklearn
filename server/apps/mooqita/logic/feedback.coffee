###############################################
@finish_feedback = (feedback, user) ->
	if not feedback.rating
		throw new Meteor.Error "Feedback: " + feedback._id + " Does not have a rating."

	if feedback.published
		throw new Meteor.Error "Feedback: " + feedback._id + " is already published."

	filter =
		feedback_id: feedback._id
	rr = ReviewRequests.findOne filter

	modify_field_unprotected Feedback, feedback._id, "published", true
	modify_field_unprotected ReviewRequests, rr._id, "feedback_done", true
	modify_field_unprotected ReviewRequests, rr._id, "feedback_finished", new Date()

	feedback = Feedback.findOne feedback._id
	send_feedback_message feedback

	msg = "Feedback (" + feedback._id + ") feedback finished by: " + get_user_mail user
	log_event msg, event_logic, event_info

	return feedback._id


###############################################
@reopen_feedback = (feedback, user) ->
	if not feedback.published
		return feedback._id

	filter =
		feedback_id: feedback._id
	rr = ReviewRequests.findOne filter

	modify_field_unprotected Feedback, feedback._id, "published", false
	modify_field_unprotected ReviewRequests, rr._id, "feedback_done", false
	modify_field_unprotected ReviewRequests, rr._id, "feedback_finished", new Date()

	msg = "Feedback (" + feedback._id + ") feedback reopened by: " + get_user_mail user
	log_event msg, event_logic, event_info

	return feedback._id



