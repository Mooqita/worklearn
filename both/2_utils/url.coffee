##########################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter

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
@build_url = (template, query, base_name="app", absolute=false, login_type="") ->
	if not base_name
		base_name = "app"

	base = if absolute then base_name else "/" + base_name
	url = FlowRouter.path base + "/" + template, null, query

	if absolute
		url = Meteor.absoluteUrl(url)

	return url

