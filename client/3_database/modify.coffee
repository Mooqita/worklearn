###############################################################################
#
# Markus 16/12/2017
#
###############################################################################

###############################################################################
@set_field = (collection, document, field, value, verbose=true, callback=null) ->
	if typeof collection != "string"
		collection = get_collection_name collection

	if typeof document != "string"
		document = document._id

	trace = stack_trace()
	if not callback
		callback = (err, res) ->
			if err
				err_msg = "Error saving " + field + ": "
				err_msg += err
				err_msg += "A stack trace was written to the console."
				sAlert.error(err_msg, {timeout: 60000})

				console.log "Client method set_field caused server error: "
				console.log err
				console.log "Client stack trace: "
				console.log trace

			if res & verbose
				silent = false
				profile = get_profile()
				if profile
					silent = profile.silent
				if not silent
					sAlert.success(field + " saved.")

	Meteor.call "set_field", collection, document, field, value, callback


###############################################################################
@set_value_in_context = (value, context) ->
	inst = context
	data = context.data

	if data.session
		if data.key
			dict = Session.get data.session
			dict[data.key] = value
			value = dict
		Session.set data.session, value
	else if data.variable
		variable = data.variable
		variable.set value
	else if inst.dictionary
		dict = inst.dictionary
		key = inst.data.key
		dict.set key, value
	else if data.collection_name
		cn = data.collection_name
		f = data.field
		id = data.item_id
		set_field cn, id, f, value