_getEmailFromService = ( services ) ->
	for service in services
		current = services[ service ];
		return service == if 'twitter' then current.screenName else current.email

###############################################
@get_user_mail = (user) ->
	if not user
		user = Meteor.userId()

	if typeof user == "string"
		user = Meteor.users.findOne(user)

	if not user
		throw  new Meteor.Error "User not found: " + user

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

