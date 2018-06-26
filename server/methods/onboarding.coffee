################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	onboard_organization: () ->
		user = Meteor.user()
		if not user
			throw new Meteor.Error "Not authorized"

		org = get_my_document Organizations
		if not org
			org_id = gen_organization()
		else
			org_id = org._id

		return org_id

	onboard_job: (data, org_id) ->
		pattern =
			role:Match.Optional(String)
			idea:Match.Optional(Number)
			team:Match.Optional(Number)
			process:Match.Optional(Number)
			strategic:Match.Optional(Number)
			contributor:Match.Optional(Number)
			social: Match.Optional(Number)
			description: Match.Optional(String)
		check data, pattern

		user = Meteor.user()
		if not user
			throw new Meteor.Error "Not authorized"

		org = Organizations.findOne(org_id)
		if not org
			org_id = gen_organization()
		else
			org_id = org._id

		data["organization_id"] = org_id
		job_id = gen_job data

		return job_id


	add_job: (organization_id) ->
		check organization_id, String

		user = Meteor.user()
		if not user
			throw new Meteor.Error "Not authorized"

		job =
			organization_id: organization_id
		job_id = gen_job job

		return job_id


	find_user: (mail) ->
		user_id = Meteor.userId()
		if not user_id
			throw new Meteor.Error "Not authorised"

		check mail, String
		if mail.length < 4
			return []

		reg = new RegExp mail
		filter =
			"emails.address":
				$regex: reg

		options =
			skip: 0
			limit: 10
			fields:
				emails: 1

		crs = Meteor.users.find filter, options
		return crs.fetch()


	invite_team_member: (organization_id, emails) ->
		check emails, [String]
		check organization_id, String

		host_id = Meteor.userId()
		if not host_id
			throw new Meteor.Error "Not authorised"

		if not is_owner Organizations, organization_id, host_id
			throw new Meteor.Error "Not authorised"

		ids = []
		host_name = get_profile_name undefined, false, false
		for email in emails
			invitation_id = gen_invitation organization_id, email, host_id, host_name
			ids.push invitation_id

		return ids


	register_to_accept_invitation: (invitation_id, password) ->
		pattern =
			algorithm: String
			digest: String
		check password, pattern

		invitation = Invitations.findOne invitation_id
		if not invitation
			throw new Meteor.error "Invitation not found."

		organization = Organizations.findOne invitation.organization_id
		host_id = invitation.host_id

		if not is_owner Organizations, organization._id, host_id
			throw new Meteor.Error "The host is not authorized to invite members."

		user =
			email: invitation.email
			password: password
		gen_user user, "employee"

		org_id = accept_invitation invitation_id
		return org_id


	accept_invitation: (invitation_id) ->
		user_id = Meteor.userId()
		if not user_id
			throw new Meteor.Error "Not authorised"

		check invitation_id, String

		org_id = accept_invitation invitation_id
		return org_id

