###############################################################
# messages
###############################################################
@event_create = "create"
@event_logic = "logic"
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
	msg = "[" + (type ? "") + "]"
	msg += "[" + (severity ? "") + "]"
	msg += " " + message ? if stack then "\n" else ""
	msg += stack ? ""

	console.log msg

#######################################################
@log_publication = (collection_name, crs, filter, fields, origin, requester_id, owner_id) ->
	origin = origin || "unknown"

	if owner_id
		p_f =
			owner_id: owner_id
		profile = Profiles.findOne p_f
		name = get_profile_name profile, true
		name += "(" + owner_id + ")"

	if requester_id
		p_f =
			owner_id: requester_id
		profile = Profiles.findOne p_f
		requester = get_profile_name profile, true
		requester += "(" + requester_id + ")"

	msg = crs.count() + " " + collection_name
	msg += if requester then " to: " + requester else ""
	msg += if name then " from: " + name else ""
	msg += " via: " + origin

	log_event msg, event_pub, event_info

#	f = JSON.stringify(filter, null, 2);
#	console.log f

#	console.log "With fields"

#	m = JSON.stringify(fields, null, 2);
#	console.log m

