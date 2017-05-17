###############################################################
# messages
###############################################################
@event_create = "create"
@event_edit = "edit"
@event_delete = "delete"
@event_pub = "publication"
@event_db = "database"
@event_file = "file"
@event_mail = "mail"
@event_testing = "testing"
@event_general = "general"

###############################################################
# severity
###############################################################
@event_imp = "important"
@event_info = "info"
@event_warn = "warning"
@event_err = "error"
@event_crit = "critical"

###############################################################
@log_event = (message, type=event_general, severity=event_info, stack="") ->
	msg = "[" + type ? "" + "]"
	msg += "[" + severity ? "" + "]"
	msg += " " + message ? if stack "\n" else ""
	msg += stack ? ""

	console.log msg

#######################################################
@log_publication = (collection_name, crs, filter, fields, origin, user_id, requester_id) ->
	data = " "

	if user_id
		p_f =
			owner_id: user_id
		profile = Profiles.findOne p_f
		name = get_profile_name profile
		name += ": " + user_id

	if requester_id
		profile = Profiles.findOne p_f
		requester = get_profile_name profile
		requester += ": " + user_id

	if filter
		data = if "owner_id" in filter then " for owner " else " "

	msg = "[count] " + crs.count()
	msg += " [collection] " + collection_name
	msg += if name then " [owner] " + name else ""
	msg += if requester then " [requester] " + requester else ""
	msg += " [origin] " + origin

	log_event msg, event_pub, event_info

#	f = JSON.stringify(filter, null, 2);
#	console.log f

#	console.log "With fields"

#	m = JSON.stringify(fields, null, 2);
#	console.log m

