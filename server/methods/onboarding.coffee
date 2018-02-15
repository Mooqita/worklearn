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
			org_id = gen_organization()
		else
			org_id = org._id

		job = get_my_document Jobs
		if not job
			data["organization_id"] = org_id
			job_id = gen_job data
		else
			job_id = job._id

		return job_id


	add_job: (organization_id) ->
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

################################################################
######################OLD OL DEV################################
################################################################

Meteor.publish "onboardingForUserPUB", () ->
  return Onboarding.find({owner_id: this.userId}, {sort: {created: -1}, limit: 1})

Meteor.methods
  existingSkills: (data) ->
    doc = Onboarding.find({owner_id: this.userId}, {sort: {created: -1}, limit: 1}).fetch()[0]
    doc.existingSkills[data.category] = data.tags
    # TODO: could use the general method, but would create another doc unnecessarily.
    Onboarding.update(doc._id, { $set: existingSkills: doc.existingSkills } )

  existingSkillsSelected: (category) ->
    # TODO: error validation & using the same type of find a lot
    existingSkills = Onboarding.find({owner_id: this.userId, existingSkills: {"$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()
    selectedExistingSkillsByCategory = existingSkills[0].existingSkills[category]
    return if selectedExistingSkillsByCategory? then selectedExistingSkillsByCategory else []

  timeComitted: (time) ->
    Meteor.call "insertOnboardingForUser", "timeComitted", time

  commtags: (data) ->
    Meteor.call "insertOnboardingForUser", "commTags", data.tags

  commtagsSelected: () ->
    commTags = Onboarding.find({owner_id: this.userId, commTags: { "$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()
    if (commTags.length == 0)
      Meteor.call "insertOnboardingForUser", "commTags", []
      return []
    else
      return commTags[0].commTags

  insertOnboardingForUser: (fieldName, data) ->
    # Does this document exist for the user?
    doc = Onboarding.find({owner_id: this.userId}, {sort: {created: -1}, limit: 1}).fetch()
    if (doc.length > 0)
      id = doc[0]._id
    else
      # If the document does not exist then first create it;
      # TODO: there is probably a simpler way to create a mongoDB schema
      id = store_document_unprotected Onboarding, {
        timeComitted: 0,
        tzIndex: 10,
        lang1Index: 20,
        lang2Index: null,
        commTags: [],
        commAny: false,
        existingSkills: {}
      }
    Onboarding.update(id, { $set: "#{''+ fieldName + ''}": data})

  lastTimeComitted: () ->
    return Onboarding.find({owner_id: this.userId, timeComitted: {"$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()[0].timeComitted

  lastTzIndex: () ->
    return Onboarding.find({owner_id: this.userId, tzIndex: {"$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()[0].tzIndex

  lastLang1Index: () ->
    return Onboarding.find({owner_id: this.userId, lang1Index: {"$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()[0].lang2Index

  lastLang2Index: () ->
    return Onboarding.find({owner_id: this.userId, lang2Index: {"$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()[0].lang2Index

  lastCommAny: () ->
    return Onboarding.find({owner_id: this.userId, commAny: {"$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()[0].commAny