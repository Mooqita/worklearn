_getEmailFromService = ( services ) ->
	for name, service of services
		if name == 'twitter'
			return service.screenName

		if name == "linkedin"
			return service.emailAddress

		return service.email

###############################################
@get_user_mail = (user) ->
	if not user
		user = Meteor.userId()

	if typeof user == "string"
		user = Meteor.users.findOne(user)

	if not user
		return undefined

	address = "unknown"
	emails   = user.emails
	services = user.services

	if emails
		address = emails[0].address
	else if services
		address =  _getEmailFromService services
	else
		address =  user.profile.name

  return address

