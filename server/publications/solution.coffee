#######################################################
#
#	Mooqita publications
# Created by Markus on 26/10/2016.
#
#######################################################

#######################################################
# item header
#######################################################

#######################################################
_solution_fields =
	fields:
		content: 1
		material: 1
		completed: 1
		published: 1
		challenge_id: 1


#######################################################
# publications
#######################################################

#######################################################
Meteor.publish "my_solutions", (admissions) ->
	user_id = this.userId

	crs = get_my_documents Solutions, {}, _solution_fields

	log_publication crs, user_id, "my_solutions"
	return crs

#######################################################
Meteor.publish "solution_by_id", (solution_id) ->
	check solution_id, String
	user_id = this.userId

	if !user_id
		throw new Meteor.Error("Not permitted.")

	#TODO: only user that are eligible should see this.

	filter =
		_id: solution_id
		published: true

	crs = Solutions.find filter, _solution_fields

	log_publication crs, user_id, "solution_by_id"
	return crs


#######################################################
Meteor.publish "my_solutions_by_challenge_id", (challenge_id, admisssions) ->
	check challenge_id, String
	user_id = this.userId

	filter = {challenge_id: challenge_id}
	crs = get_my_documents Solutions, filter, _solution_fields

	log_publication crs, user_id, "my_solutions_by_challenge_id"
	return crs


#######################################################
Meteor.publish "solutions_for_tutor", (parameter) ->
	throw new Meteor.Error("solutions_for_tutor is not implemented at the moment")
