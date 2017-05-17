################################################################
#
# Markus 1/23/2017
#
################################################################

################################################################
Meteor.methods
	log_user: (fp) ->
		headers = this.connection.httpHeaders
		con_ip = String headers["x-forwarded-for"]

		date = new Date()
		user = this.userId
		request = require('request')

		con_ip = con_ip.split(",")[0]
		url = 'http://ipinfo.io/' + con_ip + "/json"

		call = Meteor.bindEnvironment (err, res, body) ->
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

			#store_document Logging, msg
			log = JSON.stringify msg, null, 2
			log_event log, "login", event_info

		request(url, call)
		#user = if Meteor.userId() then "user: " + Meteor.userId() else "unknown user"

		return true
