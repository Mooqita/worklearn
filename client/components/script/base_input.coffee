###############################################################################
#
# Bas input functions
#
###############################################################################

###############################################################################
@get_form_value = (context) ->
	if context.session
		value = Session.get context.session
		if context.key
			if not value
				Session.set(context.session, {})
				value = Session.get(context.session)
			value = value[context.key]
	else if context.variable
		data = context.variable
		value = data.get()
	else if context.dictionary
		data = context.dictionary
		value = data.get context.key
	else if context.collection_name
		value = get_field_value context

	return value


###############################################################################
@set_form_value = (context, value) ->
	if context.session
		if context.key
			dict = Session.get context.session
			if not dict
				dict = {}
			dict[context.key] = value
			value = dict
		Session.set context.session, value
	else if context.variable
		variable = context.variable
		variable.set value
	else if inst.dictionary
		dict = inst.dictionary
		key = inst.data.key
		dict.set key, value
	else if context.collection_name
		cn = context.collection_name
		f = context.field
		id = context.item_id
		set_field cn, id, f, value



