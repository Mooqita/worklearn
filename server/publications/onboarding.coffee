###############################################################################
Meteor.publish "team_members_by_organization_id", (organization_id) ->
	check organization_id, String

	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	member_ids = []
	admission_cursor = get_admissions IGNORE, IGNORE, Organizations, organization_id
	admission_cursor.forEach (admission) ->
		member_ids.push admission.consumer_id

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

