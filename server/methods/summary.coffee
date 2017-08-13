###############################################
Meteor.methods
	export_data_to_csv: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if not Roles.userIsInRole user, "admin"
			throw new Meteor.Error('Not permitted.')

		res = [["type",	"challenge_id",	"provider_id", "provider_name",
						"recipient_id", "recipient_name",	"rating",	"content",
						"content_length"]]

		filter =
			published: true

		solutions = Solutions.find filter
		solutions.forEach (solution) ->
			r = []
			p_name = get_profile_name_by_user_id solution.owner_id, true, false
			r.push("solution")
			r.push(solution.challenge_id)
			r.push(solution.owner_id)
			r.push(p_name)
			r.push(-1)
			r.push("")
			r.push(-1)
			r.push(solution.content)
			r.push(solution.content.split(" ").length)
			res.push(r)

		reviews = Reviews.find filter
		reviews.forEach (review) ->
			r = []
			p_name = get_profile_name_by_user_id review.owner_id, true, false
			r_name = get_profile_name_by_user_id review.requester_id, true, false
			r.push("review")
			r.push(review.challenge_id)
			r.push(review.owner_id)
			r.push(p_name)
			r.push(review.requester_id)
			r.push(r_name)
			r.push(parseInt(review.rating))
			r.push(review.content)
			r.push(review.content.split(" ").length)
			res.push(r)

		feedbacks = Feedback.find filter
		feedbacks.forEach (feedback) ->
			r = []
			p_name = get_profile_name_by_user_id feedback.owner_id, true, false
			r_name = get_profile_name_by_user_id feedback.requester_id, true, false
			r.push("feedback")
			r.push(feedback.challenge_id)
			r.push(feedback.owner_id)
			r.push(p_name)
			r.push(feedback.requester_id)
			r.push(r_name)
			r.push(parseInt(feedback.rating))
			r.push(feedback.content)
			r.push(feedback.content.split(" ").length)
			res.push(r)

		zip = export_pandas_zip res, "rating_data"

		return zip
