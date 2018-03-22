################################################################
@gen_user = (user, occupation) ->
	email = user.email

	user = Accounts.createUser user
	user = Accounts.findUserByEmail email
	profile = get_profile user

	modify_field_unprotected Profiles, profile._id, "occupation", occupation
	modify_field_unprotected Profiles, profile._id, "has_occupation", true

