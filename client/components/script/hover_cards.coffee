#########################################################
#
# Hover Cards
#
#########################################################

#########################################################
Template.hover_card.helpers
	selected: () ->
		inst = Template.instance()
		context = inst.data
		value = get_form_value(context)

		if not value
			return false

		res = (value == context.value)
		return res


#########################################################
Template.hover_card.events
	"click .hover-click": () ->
		inst = Template.instance()
		context = inst.data
		value = context.value

		set_form_value(context, value)





