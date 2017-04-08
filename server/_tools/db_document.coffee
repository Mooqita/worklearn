#######################################################
#
#Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
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
	if not document.parent_id
		document["parent_id"] = ""
	if not document.single_parent
		document["single_parent"] = false

	id = collection.insert document

	return id

#######################################################
@visible_items = (user_id, owner=false, restrict={}) ->
	filter = []
	roles = ["all"]

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