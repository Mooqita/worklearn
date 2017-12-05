##############################################
@get_profile = (user_id) ->
	if not user_id
		user_id = Meteor.userId()

	filter =
		owner_id: user_id
	profile = Profiles.findOne filter

	return profile


#######################################################
@get_avatar = (profile) ->
	avatar = ""

	if profile.avatar
		if typeof profile.avatar == "number"
			avatar = download_dropbox_file Profiles, profile._id, "avatar"
		else
			avatar = profile.avatar


###############################################
@get_profile_name_by_user_id = (user_id, short = false, plus_id=true) ->
	p_f =
		owner_id: user_id
	profile = Profiles.findOne p_f

	return get_profile_name(profile, short, plus_id)


###############################################
@get_profile_name = (profile, short = false, plus_id=true) ->
	if !profile
		return "unknown"

	name = (profile.given_name ? "Learner") + " "

	if not short
		name += (profile.middle_name ? "") + " "
		name += profile.family_name ? ""

	if plus_id
		name += "("+String(profile.owner_id)+")"

	return name


###############################################
@get_profile_mail = (profile) ->
	user = Meteor.users.findOne profile.owner_id

	if not user
		return null

	return get_user_mail user


###############################################
@get_user_mail = (user) ->
	address = "unknown"

	if user.emails
		mail = user.emails[0]
		if mail
			address = mail.address

	return address


