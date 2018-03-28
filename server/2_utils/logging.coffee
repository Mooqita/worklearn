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
@event_navigation = "navigate"
@event_server = "server"

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

###############################################################
@log_error = (error) ->
	msg = "[exception]"
	msg += "[error]"
	msg += error.message
	msg += stack ? ""

	console.log msg

#######################################################
@log_publication = (cursor, user, origin) ->
	if not Array.isArray cursor
		cursor = [cursor]

	if not origin
		stack = stack_trace()
		origin = stack.split()[3]

	for crs in cursor
		description = crs._cursorDescription
		collection = description.collectionName
		filter = description.collectionName
		options = description.collectionName

		_log_publication collection, crs, filter, options, origin, user

#######################################################
_log_publication = (collection_name, crs, filter, fields, origin, user) ->
	if user
		if typeof user != "string"
			user = user._id

	origin = origin || "unknown"
	count = crs.count()

	if user
		profile = get_profile user
		if profile
			name = get_profile_name profile, true
		else
			name = "missing profile (" + user + ")"

	msg =  "[" + origin + "] "
	msg += "published [" + count + "] "
	msg += "[" + collection_name + "] "
	msg += if user then " to: " + name else ""

	log_event msg, event_pub, event_info

#	f = JSON.stringify(filter, null, 2);
#	console.log f

#	console.log "With fields"

#	m = JSON.stringify(fields, null, 2);
#	console.log m

