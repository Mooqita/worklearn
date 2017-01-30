#########################################################
@get_oauth_url = () ->
	filter =
		discover: 'upwork_oauth'
	admin = Admin.findOne(filter)

	if not admin
		return null

	url = admin.upwork_oauth_url
	return url

#########################################################
@get_oauth_requesting = () ->
	filter =
		discover: 'upwork_oauth'
	admin = Admin.findOne(filter)

	if not admin
		return null

	res = admin.upwork_oauth_requesting
	return res

#########################################################
@get_oauth_token = () ->
	oauth_token = FlowRouter.getQueryParam("oauth_token")
	oauth_verifier = FlowRouter.getQueryParam("oauth_verifier")

	res =
		oauth_token: oauth_token
		oauth_verifier: oauth_verifier

	received = !(!oauth_token or !oauth_verifier)
	if received
		return res
	else
		return null


#########################################################
Template.admin.events
	'submit #db_permission': (event) ->
		event.preventDefault()

		target = event.target

		role = target.role.value
		field = target.field.value
		types = target.types.value.split ','
		actions = target.actions.value.split ','
		collection = target.collection.value

		Meteor.call 'add_db_permission', role, collection, field, types, actions,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.info('Permission add requested: '+ res)


#########################################################
Template.admin_upwork_oauth.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe 'upwork_oauth'


#########################################################
Template.admin_upwork_oauth.events
	'click #upwork_oauth_refresh': () ->
		Meteor.call 'upwork_oauth_url',
			(err, rsp)->
				if err
					sAlert.error(err)

	'click #upwork_oauth_finish': () ->
		token = get_oauth_token()
		Meteor.call 'upwork_oauth_access', token.oauth_token, token.oauth_verifier,
			(err, rsp)->
				if err
					sAlert.error(err)


#########################################################
Template.admin_upwork_oauth.helpers
	requested_upwork_oauth_url: () ->
		return get_oauth_requesting()

	upwork_oauth_url: () ->
		return get_oauth_url()

	upwork_oauth_token: () ->
		return get_oauth_token()

	upwork_oauth_finished: () ->
		return not get_oauth_requesting()

