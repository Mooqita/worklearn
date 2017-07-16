#########################################################
Template.admin.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe "permissions"

#########################################################
Template.admin.helpers
	"permissions": ->
		filter = {}

		mod =
			sort:
				role:1
				collection_name:1
				field:1

		return Permissions.find(filter, mod)

#########################################################
Template.admin.events
	"click #remove": () ->
		Meteor.call "remove_permission", this._id,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.info("Permission removed")


	"submit #db_permission": (event) ->
		event.preventDefault()

		target = event.target

		role = target.role.value
		field = target.field.value
		types = "string".split ","
		actions = "add,modify".split ","
		collection = target.collection.value

		Meteor.call "add_db_permission", role, collection, field, types, actions,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.info("Permission added: "+ res)

#########################################################
# hashes
#########################################################

#########################################################
calc_hashes = (tmpl) ->
	num = tmpl.num.get()
	salt = tmpl.salt.get()
	template = tmpl.template.get()
	host = location.hostname
	port = if location.port then ":" + location.port else ""

	res = []
	for i in [1..num]
		index = Math.floor Math.random()*1000000000
		item =
			url: host + port + "/hit/" + template + "/" + index
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
	"change #num": (event) ->
		val = event.target.value
		Template.instance().num.set(val)
		Template.instance().hashes.set(calc_hashes(Template.instance()))

	"change #salt": (event) ->
		val = event.target.value
		Template.instance().salt.set(val)
		Template.instance().hashes.set(calc_hashes(Template.instance()))

	"change #template": (event) ->
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


Template.messages.events
	"click #send_message": (event, template) ->
		target = template.find "#message_type"
		value = target.options[target.selectedIndex].value;

		Meteor.call "send_test_message", value,
			(err, rsp)->
				if err
					sAlert.error(err)
				else
					sAlert.info("message send")
