################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
# TODO: this does not conform to mooqita's seperation of concern
# Moving logic and only keep security checks.
################################################################

################################################################
Meteor.methods
	export_data_to_csv: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if not has_role WILDCARD, WILDCARD, user, ADMIN
			throw new Meteor.Error('Not permitted.')

		res = [["solution_owner_name", "solution_owner_id",
						"review_owner_name", "review_owner_id",
						"solution_id", "challenge_id",
						"solution", "solution_length",
						"review_rating", "review_content", "review_length",
						"feedback_rating", "feedback_content", "feedback_length"]]

		filter_s =
			published: true

		solutions = Solutions.find filter_s
		solutions.forEach (solution) ->

			filter_r =
				solution_id: solution._id

			reviews = Reviews.find filter_r
			reviews.forEach (review) ->
				filter_f =
					review_id: review._id
				feedback = Feedback.findOne filter_f

				s_owner = get_document_owner Solutions, solution
				r_owner = get_document_owner Reviews, review

				s_name = get_profile_name_by_user s_owner, true, false
				r_name = get_profile_name_by_user r_owner, true, false

				r = []
				r.push(s_name)
				r.push(r_name)
				r.push(s_owner)
				r.push(r_owner)
				r.push(solution._id)
				r.push(solution.challenge_id)

				if solution.content
					r.push(solution.content)
					r.push(solution.content.split(" ").length)
				else
					r.push("")
					r.push(0)

				r.push(review.rating)
				if review.content
					r.push(review.content)
					r.push(review.content.split(" ").length)
				else
					r.push("")
					r.push(0)

				r.push(feedback.rating)
				if feedback.content
					r.push(feedback.content)
					r.push(feedback.content.split(" ").length)
				else
					r.push("")
					r.push(0)

				res.push(r)

		zip = export_pandas_zip res, "rating_data"

		return zip
