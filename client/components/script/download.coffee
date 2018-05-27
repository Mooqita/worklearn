
# Files
###############################################################################

###############################################################################
saveAs = require('file-saver').saveAs

###############################################################################
Template.download.helpers
	has_download: () ->
		return get_field_value this

	name: () ->
		if this.label
			return this.label

		field = this.field
		item_id = this.item_id
		file_name = this.file_name
		collection_name = this.collection_name

		if not file_name
			file_name = collection_name + "_" + field +
			"_" + item_id

		return file_name


###############################################################################
Template.download.events
	"click #download": () ->
		field = this.field
		item_id = this.item_id
		file_name = this.file_name
		collection_name = this.collection_name

		Meteor.call "download_file", collection_name, item_id, field,
			(err, res) ->
				if err
					sAlert.error("Download template error: " + err)
				else
					pack = unpack_item res
					blob = base64_to_blob pack.data, res.type
					if not file_name
						file_name = collection_name + "_" + field + "." + pack.extension
					saveAs blob, file_name
