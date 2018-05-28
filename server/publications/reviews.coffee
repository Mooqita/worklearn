#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
# item header
#######################################################

#######################################################
_review_fields =
	fields:
		rating: 1
		content: 1
		published: 1
		solution_id: 1
		challenge_id: 1
		requester_id: 1

#######################################################
# reviews
#######################################################

#######################################################
Meteor.publish "my_reviews", () ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	crs = get_my_documents Reviews, {}, _review_fields

	log_publication crs, user_id, "my_reviews"
	return crs


#######################################################
Meteor.publish "reviews_by_challenge_id", (challenge_id, admisssions) ->
	check challenge_id, String
	user_id = this.userId

	filter =
		challenge_id: challenge_id

	crs = get_documents user_id, IGNORE, Reviews, filter, _review_fields

	log_publication crs, user_id, "reviews_by_challenge_id"
	return crs


#######################################################
Meteor.publish "review_by_id", (review_id, admisssions) ->
	check review_id, String
	user_id = this.userId

	filter =
		_id: review_id

	crs = get_documents user_id, IGNORE, Reviews, filter, _review_fields

	log_publication crs, user_id, "reviews_by_id"
	return crs



