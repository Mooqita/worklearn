#######################################################
#
#Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
@store_document = (collection, document)->
	#TODO: add safety measures here.

	return store_document_unprotected collection, document

#######################################################
@store_document_unprotected = (collection, document)->
	document["created"] = new Date()
	document["modified"] = new Date()
	document["loaded"] = true

	if not document.owner_id
		document["owner_id"] = Meteor.userId()
	if not document.visible_to
		document["visible_to"] = "owner"
	if not document.view_order
		document["view_order"] = 1
	if not document.removal_id
		document["removal_id"] = Random.id()
	if not document.template_id
		document["template_id"] = "response"
	if not document.index
		document["index"] = -1
	if not document.parent_id
		document["parent_id"] = ""
	if not document.single_parent
		document["single_parent"] = false
	if not document.group_name
		document["group_name"] = ""

	id = collection.insert document

	return id

#######################################################
@visible_items = (user_id, restrict={}) ->
	filter = []
	roles = ["all"]

	if restrict.owner_id and user_id
		if restrict.owner_id == user_id
			owner = true

	if user_id
		# find all user roles
		roles.push "anonymous"
		user = Meteor.users.findOne user_id
		roles.push user.roles ...

	if owner
		roles.push 'owner'

	# adding a filter for all elements our current role allows us to see
	filter =
		visible_to:
			$in: roles

	for k,v of restrict
		filter[k] = v

	if not owner
		filter["deleted"] =
			$ne:
				true

	if owner
		filter["owner_id"] = user_id

	return filter