#########################################################
#
# Hover Cards
#
#########################################################

#########################################################
Template.input_button.helpers
	selected: () ->
		inst = Template.instance()
		context = inst.data
		value = get_form_value(context)

		res = (value == context.value)
		return res


#########################################################
Template.input_button.events
	"click .input-click": () ->
		inst = Template.instance()
		context = inst.data
		value = context.value

		set_form_value(value)



