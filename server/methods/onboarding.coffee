################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	add_group: () ->
		user_id = Meteor.userId()
		if not user_id
			throw new Meteor.Error "Not authorised"

		data = {}
		res = store_document_unprotected Groups, data, user_id
		return res

	add_job_post: (data) ->
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

		id = store_document_unprotected Jobs, data, user

		return id

	invite_team_member: (group_id, emails) ->
		check emails, [String]
		check group_id, String

		user_id = Meteor.userId()
		if not user_id
			throw new Meteor.Error "Not authorised"

		name = get_profile_name()
		ids = []

		for email in emails
			console.log email

			filter =
				group_id: group_id
				email: email

			crs = Invitations.find filter
			if crs.count() > 0
				continue

			if not is_owner Groups, group_id, user_id
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

		reg = new RegExp mail
		check mail, String
		filter =
			"emails.address":
				$regex: reg

		options =
			skip: 0
			limit: 10
			fields:
				emails: 1

		crs = Meteor.users.find filter, options
		console.log crs.count()

		return crs.fetch()

