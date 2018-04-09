################################################################
@gen_organization = (org, user) ->
	if not user
		user = Meteor.userId()

	if typeof user != "string"
		user = user._id

	if not org
		org =
			name: ""
			description: ""

	org_id = store_document_unprotected Organizations, org, user, true
	return org_id
