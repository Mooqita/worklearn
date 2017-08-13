###############################################
Meteor.methods
	export_data_to_csv: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if not Roles.userIsInRole user, "admin"
			throw new Meteor.Error('Not permitted.')

		res =
			type: []
			challenge_id: []
			provider_id: []
			provider_name: []
			recipient_id: []
			recipient_name: []
			rating: []
			content: []
			content_length: []

		filter =
			published: true

		solutions = Solutions.find filter
		solutions.forEach (solution) ->
			p_name = get_profile_name_by_user_id solution.owner_id, true, false
			res["type"] = 1
			res["challenge_id"] = solution.challenge_id
			res["provider_id"] = solution.owner_id
			res["provider_name"] = p_name
			res["recipient_id"] = -1
			res["recipient_name"] = ""
			res["rating"] = -1
			res["content"] = solution.content
			res["content_length"] = solution.content.split(" ").length

		reviews = Reviews.find filter
		reviews.forEach (review) ->
			p_name = get_profile_name_by_user_id review.provider_id, true, false
			r_name = get_profile_name_by_user_id review.requester_id, true, false
			res["type"] = 2
			res["challenge_id"] = review.challenge_id
			res["provider_id"] = review.owner_id
			res["provider_name"] = p_name
			res["recipient_id"] = review.requester_id
			res["recipient_name"] = r_name
			res["rating"] = parseInt(review.rating)
			res["content"] = review.content
			res["content_length"] = review.content.split(" ").length

		feedbacks = Feedback.find filter
		feedbacks.forEach (feedback) ->
			p_name = get_profile_name_by_user_id review.provider_id, true, false
			r_name = get_profile_name_by_user_id review.requester_id, true, false
			res["type"] = 3
			res["challenge_id"] = feedback.challenge_id
			res["provider_id"] = feedback.owner_id
			res["provider_name"] = p_name
			res["recipient_id"] = feedback.requester_id
			res["recipient_name"] = r_name
			res["rating"] = parseInt(feedback.rating)
			res["content"] = feedback.content
			res["content_length"] = feedback.content.split(" ").length

		zip = export_pandas_zip res, "rating_data"

		return zip
