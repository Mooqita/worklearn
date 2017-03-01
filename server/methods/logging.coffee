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
		con_ip = String(this.connection.clientAddress)
		headers = this.connection.httpHeaders
		date = new Date()
		user = this.userId
		request = require('request')
		url = 'http://ipinfo.io/' + con_ip

		call = Meteor.bindEnvironment (err, res, body) ->
			console.log body
			ip = JSON.parse(body)

			msg =
				date: date
				print: fp
				user: user
				con_ip: con_ip

			merge msg, headers
			merge msg, ip

			if err
				msg["error"] = err

			Logging.insert msg

		request url, call