###############################################
Meteor.methods
	add_recommendation: (challenge_id, recipient_id) ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		challenge = find_document Challenges, challenge_id, true
		if challenge.owner_id != user._id
			throw new Meteor.Error('Not permitted.')

		return gen_recommendation user, recipient_id


	finish_recommendation: (recommendation_id) ->
		user = Meteor.user()
		recommendation = find_document Recommendations, recommendation_id, true

		return finish_recommendation recommendation, user

