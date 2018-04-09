#####################################################
# Permissions
#####################################################

#####################################################
@initialize_permissions = () ->
	log_event "Inserting default permissions"

	asset_path = "db/defaultcollections/permissions.json"
	asset_pobj = Meteor.settings.default_permissions_asset_path

	if asset_pobj
		assetp = asset_pobj.toString()
		if not assetp == ""
			asset_path = assetp

	perms_txt = Assets.getText(asset_path)
	perms = JSON.parse(perms_txt)

	for perm, i in perms
		_insert_permission_safe(perm)


#####################################################
# Helper functions to fill in default permissions
#####################################################

#####################################################
_find_permission_by_effectors = (p) ->
	filter =
		role: p.role
		field: p.field
		collection_name: p.collection_name
	Permissions.find(filter)


#####################################################
_insert_permission_unsafe = (p) ->
	id = Permissions.insert p

	if not id
		throw new Meteor.Error 'Could not insert permission to db : ' + p

	return id


#####################################################
_insert_permission_safe = (p) ->
	existing_permission = _find_permission_by_effectors(p)

	if existing_permission.count() == 0
		_insert_permission_unsafe(p)
	else
		#msg = "Permission already exists: " + JSON.stringify(p)
		#log_event msg, event_db, event_info

