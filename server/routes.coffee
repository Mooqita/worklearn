###############################################################################
# Server side routing to provide api's and data formats such as json or xml
###############################################################################

###############################################################################
WebApp.connectHandlers.use '/remeeting/quiz', (req, res, next) ->
	console.log(JSON.stringify(req.headers))
	console.log(JSON.stringify(req.params))
	console.log(JSON.stringify(req.query))

	res.writeHead(200)
	data = Assets.getText('remeet_quiz.html')
	res.end(data)

###############################################################################
WebApp.connectHandlers.use '/remeeting/quiz_python_script.cgi', (req, res, next) ->
	console.log(JSON.stringify(req.headers))
	console.log(JSON.stringify(req.params))
	console.log(JSON.stringify(req.query))

	res.writeHead(200)

	if req._body == true
		n = req.body.number
		if isNaN(n)
			data = Assets.getText('remeet_except.html')
		else if Number(n) == 144
			data = Assets.getText('remeet_right.html')
		else
			data = Assets.getText('remeet_wrong.html')
			data = data.replace("{{n}}", Number(n))

	res.end(data)

###############################################################################
JsonRoutes.add "get", "/remeeting/numbers.json", (req, res, next) ->
	console.log(JSON.stringify(req.headers))
	console.log(JSON.stringify(req.params))
	console.log(JSON.stringify(req.query))

	JsonRoutes.sendResult res, {data:{"favorite": 4, "least_favorite": 6}}


###############################################################################
JsonRoutes.add "get", "/api/0.1/cert_issuer/:issuer_id", (req, res, next) ->
	console.log(JSON.stringify(req.headers))
	console.log(JSON.stringify(req.params))
	console.log(JSON.stringify(req.query))

	id = req.params.issuer_id
	issuer = issuer_from_user_id(id)
	JsonRoutes.sendResult res, {data: issuer}

