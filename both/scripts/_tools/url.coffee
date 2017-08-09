##########################################################
@valid_url = (str)->
	pattern = new RegExp '^(https?:\/\/)?'+ 					# protocol
		'((([a-z\d]([a-z\d-]*[a-z\d])*)\.)+[a-z]{2,}|'+ # domain name
		'((\d{1,3}\.){3}\d{1,3}))'+ 										# OR ip (v4) address
		'(\:\d+)?(\/[-a-z\d%_.~+]*)*'+ 									# port and path
		'(\?[;&a-z\d%_.~+=-]*)?'+ 											# query string
		'(\#[-a-z\d_]*)?$','i' 													# fragment locator

	if pattern.test str
		return true

	return false

##############################################
@build_url = (template, query, absolute=false) ->
	app = if absolute then "app" else "/app"
	url = FlowRouter.path app+"/"+template, null, query

	if absolute
		url = Meteor.absoluteUrl(url)

	return url

