###############################################
@gen_message = (user, title, message, url) ->
	#save message
	msg =
		visible_to: OWNER
		content: message
		title: title
		seen: false
		url: url

	m_id = store_document_unprotected Messages, msg, user

	return m_id


###############################################
@finish_message = (message_id) ->
	return modify_field_unprotected Messages, message_id, "seen", true


###############################################
@send_review_message = (review) ->
	challenge = Challenges.findOne review.challenge_id
	solution = Solutions.findOne review.solution_id
	owner = get_document_owner "solutions", solution
	solution_profile = get_profile owner._id

	subject = "Mooqita: You got a new review"
	url = build_url "challenge", {challenge_id: challenge._id}, true, "learner"

	name = if solution_profile then solution_profile.given_name ? "learner" else "learner"

	body = "Hi " + name + ",\n\n"
	body += "You received a new review in: \n"
	body += challenge.title + "\n\n"
	body += "To check it out, follow this link: " + url + "\n\n"
	body += "Kind regards, \n"
	body += " Your Mooqita Team \n\n"

	body += "You can disable mail notifications in your profile: " +
					"" + build_url "profile", {}, true, "learner"

	send_message_mail owner, subject, body

	title = "New Review"
	text = "You received a new review on one of your solutions in: "
	text += challenge.title + " "

	gen_message owner, title, text, url

	return true


@send_review_timeout_message = (review) ->
	challenge = Challenges.findOne review.challenge_id
	solution = Solutions.findOne review.solution_id
	owner = get_document_owner "reviews", review
	review_profile = get_profile owner._id

	subject = "Mooqita: A review timed out"
	url = build_url "challenge", {challenge_id: challenge._id}, false, "learner"

	name = if review_profile then review_profile.given_name ? "learner" else "learner"

	body = "Hi " + name + ",\n\n"
	body += "One of the reviews you were working on timed out in: \n"
	body += challenge.title + "\n\n"
	body += "To ensure that everyone gets reviews in time.\n"
	body += "Reviews time out after 24 hours. After this time\n"
	body += "they are again available for other reviewers.\n\n"
	body += "Kind regards, \n"
	body += " Your Mooqita Team \n\n"

	body += "You can disable mail notifications in your profile: " +
					build_url "learner_profile", {}, true

	send_message_mail owner, subject, body

	title = "Review timeout"
	text = "One of the reviews you were working on timed out in: "
	text += challenge.title + " "
	text += "To ensure that everyone gets reviews in time. "
	text += "Reviews time out after 24 hours. After this time "
	text += "they are again available for other reviewers."

	gen_message owner, title, text, url

	return true

###############################################
@send_feedback_message = (feedback) ->
	challenge = Challenges.findOne feedback.challenge_id
	solution = Solutions.findOne feedback.solution_id
	review = Reviews.findOne feedback.review_id
	owner = get_document_owner "reviews", review
	review_profile = get_profile owner._id

	param =
		review_id: review._id
		solution_id: solution._id
		challenge_id: challenge._id

	url = build_url "learner_review", param, true, "learner"
	subject = "Mooqita: New feedback for your reviews"

	name = if review_profile then review_profile.given_name ? "user" else "user"

	body = "Hi " + name + ",\n\n"
	body += "You received feedback to one of your reviews in: \n"
	body += challenge.title + "\n\n"
	body += "To check it out, follow this link: " + "https://mooqita.org" + url + "\n\n"
	body += "Kind regards, \n"
	body += " Your Mooqita Team \n\n"

	body += "You can disable mail notifications in your profile: "+
					build_url "profile", {}, true, "learner"

	send_message_mail owner, subject, body, url

	title = "New Feedback"
	text = "You received new feedback on one of your reviews in: "
	text += challenge.title

	gen_message owner, title, text, url

	return true