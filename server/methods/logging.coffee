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

		console.log this.connection.clientAddress
		console.log con_ip

		con_ip = con_ip.split ","[0]
		url = 'http://ipinfo.io/' + con_ip + "/json"

		console.log con_ip

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

			console.log "merging"
			merge msg, headers
			merge msg, ip

			console.log "merged"
			if err
				console.log "error merging"
				msg["error"] = err
				console.log "error merged"

			console.log "inserting"
			Logging.insert msg
			console.log "done"

		request url, call
		console.log "called"