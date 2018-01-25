################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	onboard_organization: (data) ->
		pattern =
			role:String,
			idea:Number,
			team:Number,
			process:Number,
			strategic:Number
		check data, pattern

		user = Meteor.user()
		if not user
			throw new Meteor.Error "Not authorized"

		org = get_my_document Organizations
		if not org
			org_id = store_document_unprotected Organizations, {}, user
			org = Organizations.findOne org_id

		job = get_my_document Jobs
		if not job
			data["company_id"] = org._id
			job_id = store_document_unprotected Jobs, data, user
			job = Jobs.findOne job_id

		return job._id

	invite_team_member: (organization_id, emails) ->
		check emails, [String]
		check organization_id, String

		user_id = Meteor.userId()
		if not user_id
			throw new Meteor.Error "Not authorised"

		name = get_profile_name()
		ids = []

		for email in emails
			filter =
				organization_id: organization_id
				email: email

			crs = Invitations.find filter
			if crs.count() > 0
				continue

			if not is_owner Organizations, organization_id, user_id
				throw new Meteor.Error "Not authorised"

			filter["host"] = user_id
			invitation_id = store_document_unprotected Invitations, filter, user_id
			ids.push invitation_id

			url = build_url "invitation", {invitation_id: invitation_id}, true

			subject = "Mooqita: Invitation from " + name
			body = name + " has send you an invitation to join Mooqita."
			body += "Please follow this link: " + url
			body += "to check out the invitation. You can chose on the website if you want to join or not."
			send_mail email, subject, body

		return ids


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

