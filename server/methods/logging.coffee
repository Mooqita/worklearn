################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
merge = (dest, objs...) ->
	for obj in objs
		dest[k] = v for k, v of obj
	return dest

################################################################
Meteor.methods
	log_user: (fp) ->
		headers = this.connection.httpHeaders
		date = new Date()
		user = this.userId

		call = Meteor.bindEnvironment (err, ip) ->
			msg =
				date: date
				print: fp
				user: user

			merge msg, headers
			merge msg, ip

			if err
				msg["error"] = err

			Logging.insert msg

		IPinfo = require 'get-ipinfo'
		IPinfo this.connection.clientAddress, call