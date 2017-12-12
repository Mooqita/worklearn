################################################################
#
# Markus 1/23/2017
#
################################################################

###############################################
Meteor.methods
	add_recommendation: (challenge_id, recipient_id) ->
		user = Meteor.user()
		if not user
			throw new Meteor.Error('Not permitted.')

		if not can_edit Challenges, challenge_id, user
			throw new Meteor.Error('Not permitted.')

		return gen_recommendation user, recipient_id


	finish_recommendation: (recommendation_id) ->
		user = Meteor.user()
		if not user
			throw new Meteor.Error('Not permitted.')

		if not can_edit Recommendations, recommendation_id, user
			throw new Meteor.Error 'Not permitted.'

		recommendation = get_document_unprotected Recommendations, recommendation_id
		return finish_recommendation recommendation, user

