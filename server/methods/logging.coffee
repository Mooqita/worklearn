################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	log_user: (fp) ->
		msg =
			time: new Date()
			print: fp
			user: this.userId
			ip: this.connection.clientAddress

		Logging.insert msg