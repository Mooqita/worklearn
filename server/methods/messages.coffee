################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	notify_support:(subject) ->
		check subject, String

		user = Meteor.user()
		if not user
			throw new Meteor.Error("You need to be logged in to message the support staff.")

		name = get_profile_name_by_user_id(user)
		email = get_user_mail(user)

		content = "User: " + name + "\n"
		content += "e-Mail: " + email

		to = "info@mooqita.org"
		send_mail(to, "THIS IS A TEXT: " + subject, content)
		return email
