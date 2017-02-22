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
Template.admin.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe 'permissions'

#########################################################
Template.admin.helpers
	"permissions": ->
		return Permissions.find()

#########################################################
Template.admin.events
	"click #remove": () ->
		Meteor.call "remove_permission", this._id,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.info('Permission removed')


	'submit #db_permission': (event) ->
		event.preventDefault()

		target = event.target

		role = target.role.value
		field = target.field.value
		types = "string".split ','
		actions = "add,modify".split ','
		collection = target.collection.value

		Meteor.call 'add_db_permission', role, collection, field, types, actions,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.info('Permission add requested: '+ res)

#########################################################
# hashes
#########################################################

#########################################################
calc_hashes = (tmpl) ->
	num = tmpl.num.get()
	salt = tmpl.salt.get()
	template = tmpl.template.get()
	host = location.hostname
	port = if location.port then ':' + location.port else ''

	res = []
	for i in [1..num]
		index = Math.floor Math.random()*1000000000
		item =
			url: host + port + "/hit/" + template + '/' + index
			hash: calculate_response_hash(index, salt, template)
		res.push item

	return res


#########################################################
Template.hashes.onCreated ->
	this.num = new ReactiveVar(0)
	this.salt = new ReactiveVar("")
	this.hashes = new ReactiveVar([])
	this.template = new ReactiveVar("")

#########################################################
Template.hashes.events
	'change #num': (event) ->
		val = event.target.value
		Template.instance().num.set(val)
		Template.instance().hashes.set(calc_hashes(Template.instance()))

	'change #salt': (event) ->
		val = event.target.value
		Template.instance().salt.set(val)
		Template.instance().hashes.set(calc_hashes(Template.instance()))

	'change #template': (event) ->
		val = event.target.value
		Template.instance().template.set(val)
		Template.instance().hashes.set(calc_hashes(Template.instance()))


#########################################################
Template.hashes.helpers
	num:() ->
		return Template.instance().num.get()

	salt:() ->
		return Template.instance().salt.get()

	template:() ->
		return Template.instance().template.get()

	hashes: () ->
		return Template.instance().hashes.get()


#########################################################
# upwork_oauth
#########################################################

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

