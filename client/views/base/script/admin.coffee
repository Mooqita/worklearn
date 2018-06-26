###############################################################################
saveAs = require('file-saver').saveAs


###############################################################################
Template.mooqita_admin.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe "permissions"

###############################################################################
Template.mooqita_admin.helpers
	"permissions": ->
		filter = {}

		mod =
			sort:
				role:1
				collection_name:1
				field:1

		return Permissions.find(filter, mod)

###############################################################################
Template.mooqita_admin.events
	"click #download_csv": () ->
		Meteor.call "export_data_to_csv",
			(err, res) ->
				sAlert.error("done export")
				console.log [err,res]
				if err
					sAlert.error("CSV export error: " + err)
				else
					sAlert.error("success")
					blob = base64_to_blob res, "application/zip"
					saveAs blob, "responses.zip"

	"click #remove": () ->
		Meteor.call "remove_permission", this._id,
			(err, res) ->
				if err
					sAlert.error("Remove permission error: " + err)
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
					sAlert.error("Add permission error: " + err)
				else
					sAlert.info("Permission added: "+ res)
