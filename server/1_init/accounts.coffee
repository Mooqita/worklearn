##########################################################
# login and accounts
##########################################################

###############################################
Accounts.onCreateUser (options, user) ->
	occupation = undefined
	if options.profile
		occupation = options.profile.occupation

	gen_profile user, occupation
	return user

