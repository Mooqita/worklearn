###############################################
@gen_message = (user_id, title, message, url) ->
	#save message
	msg =
		owner_id: user_id
		content: message
		title: title
		seen: false
		url: url

	m_id = store_document Messages, msg

	return m_id


###############################################
@finish_message = (message_id) ->
	return modify_field_unprotected Messages, message_id, "seen", true


###############################################
@send_review_message = (review) ->
	challenge = Challenges.findOne review.challenge_id
	solution = Solutions.findOne review.solution_id

	filter =
		owner_id: solution.owner_id
	solution_profile = Profiles.findOne filter

	subject = "Mooqita: You got a new review"
	url = "user?template=student_solution&challenge_id=" + challenge._id

	name = if solution_profile then solution_profile.given_name ? "user" else "user"

	body = "Hi " + name + ",\n\n"
	body += "You received a new review. \n"
	body += "To check it out, follow this link: " +  "www.mooqita.org/" + url + "\n\n"
	body += "Kind regards, \n"
	body += " Your Mooqita Team \n\n"

	body += "You can disable mail notifications in your profile: " +
					"www.mooqita.org/" + "user?template=student_profile\n"

	send_message_mail solution.owner_id, subject, body

	title = "New Review"
	text = "You received a new review on one of your solutions."
	gen_message solution.owner_id, title, text, url

	return true


@send_review_timeout_message = (review) ->
	challenge = Challenges.findOne review.challenge_id
	solution = Solutions.findOne review.solution_id

	filter =
		owner_id: review.owner_id
	review_profile = Profiles.findOne filter

	subject = "Mooqita: A review timed out"
	url = "user?template=student_solution&challenge_id=" + challenge._id

	name = if review_profile then review_profile.given_name ? "user" else "user"

	body = "Hi " + name + ",\n\n"
	body += "One of the reviews you were working on timed out. \n"
	body += "To ensure that everyone gets reviews in time.\n"
	body += "Reviews time out after 24 hours. After this time\n"
	body += "they are again available for other reviewers.\n\n"
	body += "Kind regards, \n"
	body += " Your Mooqita Team \n\n"

	body += "You can disable mail notifications in your profile: " +
					"www.mooqita.org/" + "user?template=student_profile\n"

	send_message_mail review.owner_id, subject, body

	title = "Review timeout"
	text = "One of the reviews you were working on timed out. To ensure that everyone gets reviews in time. Reviews time out after 24 hours. After this time they are again available for other reviewers."

	gen_message review.owner_id, title, text, url

	return true

###############################################
@send_feedback_message = (feedback) ->
	challenge = Challenges.findOne feedback.challenge_id
	solution = Solutions.findOne feedback.solution_id
	review = Reviews.findOne feedback.review_id

	filter =
		owner_id: review.owner_id
	review_profile = Profiles.findOne filter

	subject = "Mooqita: New feedback for your reviews"
	url = "user?template=student_review" +
		"&review_id=" + review._id +
		"&solution_id=" + solution._id +
		"&challenge_id=" + challenge._id

	name = if review_profile then review_profile.given_name ? "user" else "user"

	body = "Hi " + name + ",\n\n"
	body += "You received feedback to one of your reviews. \n"
	body += "To check it out, follow this link: " + url + "\n\n"
	body += "Kind regards, \n"
	body += " Your Mooqita Team \n\n"

	body += "You can disable mail notifications in your profile: "+
					"www.mooqita.org/" + "user?template=student_profile\n"

	send_message_mail review.owner_id, subject, body, url

	title = "New Feedback"
	text = "You received new feedback on one of your reviews."
	gen_message review.owner_id, title, text, url

	return true