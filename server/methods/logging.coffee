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
		con_ip = String(headers["x-forwarded-for"])
		date = new Date()
		user = this.userId
		request = require('request')
		url = 'http://ipinfo.io/' + con_ip + "/json"
		console.log url

		call = Meteor.bindEnvironment (err, res, body) ->
			console.log err
			console.log body

			if !err && res.statusCode == 200
				ip = JSON.parse(body)
			else
				ip =
					error: err
					body: body

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