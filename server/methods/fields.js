// Server Helper Methods That Can Be Used For Fields Of All Collections

Meteor.methods({
    set_field: (collection_name, item_id, field, data) => {
		var collection = get_collection_save(collection_name)
		return modify_field(collection, item_id, field, data)
    },

	upload_file: (collection_name, item_id, field, data, type) => {
		var collection = get_collection_save(collection_name)
		return upload_file(collection, item_id, field, data, type)
    },

	download_file: (collection_name, item_id, field) => {
		var collection = get_collection_save(collection_name)
		return download_file(collection, item_id, field)
    }
})
