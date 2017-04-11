#########################################################
# Files
#########################################################

########################################
import { saveAs } from 'file-saver'

#########################################################
Template.download.helpers
	has_download: () ->
		return get_field_value this

	name: () ->
		field = this.field
		item_id = this.item_id
		file_name = this.file_name
		collection_name = this.collection_name

		if not file_name
			file_name = collection_name + "_" + field +
			"_" + item_id

		return file_name


#########################################################
Template.download.events
	"click #download": () ->
		field = this.field
		item_id = this.item_id
		file_name = this.file_name
		collection_name = this.collection_name

		Meteor.call "download_file", collection_name, item_id, field,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					console.log res
					data = unpack_item res
					blob = base64_to_blob data
					if not file_name
						file_name = collection_name + "_" + field +
										"_" + item_id + "." + res.extension
					saveAs blob, file_name


#########################################################
Template.image_field.onCreated ->
	self = this
	self.image_src = new ReactiveVar("")

	field = this.data.field
	item_id = this.data.item_id
	collection_name = this.data.collection_name

	Meteor.call "download_file", collection_name, item_id, field,
		(err, res) ->
			if err
				sAlert.error(err)
			else
				self.image_src.set res.data

#########################################################
Template.image_field.helpers
	data: () ->
		inst = Template.instance()
		return inst.image_src.get()