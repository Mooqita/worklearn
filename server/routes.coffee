###############################################################################
# Server side routing to provide api's and data formats such as json or xml
###############################################################################

###############################################################################
JsonRoutes.add "get", "/api/0.1/cert_issuer/:issuer_id", (req, res, next) ->
	console.log(JSON.stringify(req.headers))
	console.log(JSON.stringify(req.params))
	console.log(JSON.stringify(req.query))

	id = req.params.issuer_id
	issuer = issuer_from_user_id(id)
	JsonRoutes.sendResult res, {data: issuer}

