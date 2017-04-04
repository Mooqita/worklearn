@save_document = (collection, document)->
	document["created"] = new Date()
	document["modified"] = new Date()
	document["loaded"] = true

	if not document.owner_id
		document["owner_id"] = Meteor.userId()
	if not document.visible_to
		document["visible_to"] = "owner"
	if not document.view_order
		document["view_order"] = 1
	if not document.template_id
		document["template_id"] = "response"
	if not document.type_identifier
		document["type_identifier"] = "undefined"
	if not document.index
		document["index"] = -1
	if not document.single_parent
		document["single_parent"] = false

	id = collection.insert document

	return id
