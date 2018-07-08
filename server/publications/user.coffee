###############################################################################
#
#	Mooqita
# Created by Markus on 20/8/2017.
#
###############################################################################

###############################################################################
Meteor.publish "find_users_by_mail": (mail_fragment) ->
	user = Meteor.user()
	if not user
		throw new Meteor.Error('Not permitted.')

	if mail_fragment.length < 5
		return []

	check mail_fragment, String
	filter =
		emails:
			$elemMatch:
				address:
					$regex : new RegExp(mail_fragment, "i")

	options =
		fields:
			emails: 1
		skip: 0,
		limit: 10

	crs = Meteor.users.find filter, options
	users = crs.fetch()

	return users

###############################################################################
Meteor.publish "my_profile", () ->
	user_id = this.userId

	if not user_id
		user_id = ""

	filter =
		user_id: user_id

	crs = Profiles.find filter
	log_publication crs, user_id, "my_profile"

	return crs

###############################################################################
# Resumes
###############################################################################

###############################################################################
Meteor.publish "user_resumes", (user_id) ->
	if user_id
		check user_id, String

	if !user_id
		user_id = this.userId

	if !user_id
		throw new Meteor.Error("Not permitted.")

	self = this
	prepare_resume = (user) ->
		resume = gen_resume(user)
		self.added("user_resumes", user._id, resume)

	filter =
		_id: user_id

	crs = Meteor.users.find(filter)
	crs.forEach(prepare_resume)

	log_publication crs, user_id, "user_resumes"
	self.ready()


#######################################################
Meteor.publish "user_resumes_by_matched_challenges", (matches) ->
	match =
		_id: String
		cb: String
		ids: [String]

	check matches, [match]

	user_id = this.userId
#	if not user_id
#		throw new Meteor.Error("Not permitted")

	ids = (i.ids[1] for i in matches)
	flr = {challenge_id:{$in:ids}}
	mod = {fields:{_id:1}}
	solution_ids = (i._id for i in Solutions.find(flr, mod).fetch())
	owner_ids = get_document_owners(Solutions, solution_ids)

	self = this
	prepare_resume = (user) ->
		resume = gen_resume(user)
		self.added("user_resumes", user._id, resume)

	filter =
		_id:
			$in:owner_ids

	crs = Meteor.users.find(filter)
	crs.forEach(prepare_resume)

	log_publication crs, user_id, "user_resumes_by_matched_challenges"
	self.ready()


#######################################################
Meteor.publish "users_by_matched_challenges", (matches) ->
	match =
		_id: String
		cb: String
		ids: [String]

	check matches, [match]

	user_id = this.userId
#	if not user_id
#		throw new Meteor.Error("Not permitted")

	ids = (i.ids[1] for i in matches)
	flr = {challenge_id:{$in:ids}}
	mod = {fields:{_id:1}}
	solution_ids = (i._id for i in Solutions.find(flr, mod).fetch())
	owner_ids = get_document_owners(Solutions, solution_ids)

	self = this
	prepare_resume = (user) ->
		resume = {}
		self.added("user_resumes", user._id, resume)

	filter =
		_id:
			$in:owner_ids

	crs = Meteor.users.find(filter)
	crs.forEach(prepare_resume)

	log_publication crs, user_id, "user_resumes_by_matched_challenges"
	self.ready()


###############################################################################
Meteor.publish "user_summary", (user_id, challenge_id) ->
	check user_id, String
	check challenge_id, String

	if user_id
		if not has_role Challenges, challenge_id, this.userId, DESIGNER
			throw new Meteor.Error("Not permitted.")

	if !user_id
		user_id = this.userId

	if !user_id
		throw new Meteor.Error("Not permitted.")

	#############################################################################
	# Initialize user summary through users
	# database object
	#############################################################################

	mod =
		fields:
			emails: 1

	user = Meteor.users.findOne user_id, mod

	#############################################################################
  # Same fields for solution review feedback
	#############################################################################
	mod =
		fields:
			rating: 1
			content: 1
			material: 1

	#############################################################################
	# Find Solutions
	#############################################################################

	#############################################################################
	filter = {challenge_id: challenge_id}
	solutions = get_my_documents filter, mod

	#############################################################################
	# Find relevant Feedback and Reviews
	#############################################################################
	rev_given = get_my_documents Reviews.find filter, mod
	fed_given = get_my_documents Feedback.find filter, mod

	filter =
		requester_id: user_id
		challenge_id: challenge_id
	rev_received = Reviews.find filter, mod
	fed_received = Feedback.find filter, mod

	#############################################################################
	#
	# Calculate statistics
	#
	#############################################################################

	#############################################################################
	# Solutions
	#############################################################################
	material = 0
	length = 0
	count = solutions.count()
	solutions.forEach (entry) ->
		if entry.content
			length += entry.content.split(" ").length
		if entry.material
			material += 1

	user.solutions_count = count
	user.solutions_average_length = length / count
	user.solutions_average_material = material / count

	#############################################################################
	# Given Reviews
	#############################################################################
	user = calc_statistics user, rev_given, "reviews_given"
	user = calc_statistics user, rev_received, "reviews_received"
	user = calc_statistics user, fed_given, "feedback_given"
	user = calc_statistics user, fed_received, "feedback_received"

	log_publication crs, this.userId, "user_summary"
	this.added "user_summaries", user_id, user
	this.ready()


###############################################################################
Meteor.publish "team_members_by_organization_id", (organization_id) ->
	check organization_id, String

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	member_ids = []
	admission_cursor = get_admissions IGNORE, IGNORE, Organizations, organization_id
	admission_cursor.forEach (admission) ->
		member_ids.push admission.u

	options =
		fields:
			given_name: 1
			middle_name: 1
			family_name: 1
			big_five: 1
			avatar:1

	self = this
	for user_id in member_ids
		profile = Profiles.findOne {user_id: user_id}, options
		mail = get_user_mail(user_id)
		name = get_profile_name profile, false, false

		member =
			name: name
			email: mail
			big_five: profile.big_five
			avatar: profile.avatar
			owner: user_id == self.userId

		self.added("team_members", user_id, member)

	log_publication admission_cursor, user_id, "team_members_by_organization_id"
	self.ready()

