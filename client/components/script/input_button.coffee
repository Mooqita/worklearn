#########################################################
#
# Hover Cards
#
#########################################################

#########################################################
Template.input_button.helpers
	selected: () ->
		context = Template.instance()
		value = get_value_from_context(context)

		if not value
			return false

		res = (value == context.data.value)
		return res


#########################################################
Template.input_button.events
	"click .input-click": () ->
		context = Template.instance()
		value = context.data.value

		set_value_in_context(value, context)





