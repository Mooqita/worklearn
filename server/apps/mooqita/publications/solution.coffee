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
		owner_id: 1
		completed: 1
		published: 1
		parent_id: 1
		challenge_id: 1


#######################################################
# publications
#######################################################

#######################################################
Meteor.publish "my_solutions", () ->
	user_id = this.userId
	restrict =
		owner_id: user_id

	filter = visible_items user_id, restrict
	crs = Solutions.find filter, _solution_fields

	log_publication "Solutions", crs, filter,
			_solution_fields, "my_solutions", user_id
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

	log_publication "Solutions", crs, filter,
			_solution_fields, "solution_by_id", user_id
	return crs


#######################################################
Meteor.publish "my_solution_by_id", (solution_id) ->
	check solution_id, String
	user_id = this.userId

	restrict =
		_id: solution_id
		owner_id: user_id

	filter = visible_items user_id, restrict
	crs = Solutions.find filter, _solution_fields

	log_publication "Solutions", crs, filter,
			_solution_fields, "my_solution_by_id", user_id
	return crs


#######################################################
Meteor.publish "my_solutions_by_challenge_id", (challenge_id) ->
	check challenge_id, String
	user_id = this.userId

	restrict =
		owner_id: user_id
		challenge_id: challenge_id

	filter = visible_items user_id, restrict
	crs = Solutions.find filter, _solution_fields

	log_publication "Solutions", crs, filter,
			_solution_fields, "my_solutions_by_challenge_id", user_id
	return crs


#######################################################
Meteor.publish "solutions_for_tutor", (parameter) ->
	pattern =
		query: Match.Optional(String)
		challenge_id: String
		page: Number
		size: Number
	check parameter, pattern

	self = this
	user_id = this.userId

	if not Roles.userIsInRole user_id, "tutor"
		throw new Meteor.Error("Not permitted.")

	gen_tut = (id) ->
		review = Reviews.findOne id
		solution = Solutions.findOne review.solution_id
		date = review.requested
		now = new Date()
		difference = now - date
		item =
			solution_id: rr.solution_id
			content: solution.content
			material: solution.material
			date: date
			wait: how_much_time difference

		return item

	filter =
		challenge_id: parameter.challenge_id
		owner_id:
			$ne: user_id
		review_done: false

	mod =
		sort:
			under_review_since: 1

	crs = paged_find ReviewRequests, filter, mod, parameter
	handler = crs.observeChanges
		added: (id, fields) ->
			credit = gen_tut id
			self.added "tutor_solutions", id, credit

		changed: (id, fields) ->
			credit = gen_credit id
			self.changed "tutor_solutions", id, credit

		removed: (id) ->
      self.removed "tutor_solutions", id

	self.ready()
	self.onStop ->
    handler.stop()

