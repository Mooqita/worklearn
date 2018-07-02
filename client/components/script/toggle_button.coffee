#########################################################
#
# Toggle Button
#
#########################################################

#########################################################
Template.toggle_button.onCreated ->
	this.id = "id_" + Random.id()

#########################################################
Template.toggle_button.helpers
	checked: () ->
		inst = Template.instance()
		context = inst.data
		value = get_form_value(context)

		on_value = 1
		off_value = 0
		if context.on_value
			on_value = context.on_value

		if context.off_value
			off_value = context.off_value

		if value == on_value
			return "checked"

		return ""

	id: () ->
		instance = Template.instance()
		return instance.id


#########################################################
Template.toggle_button.events
	"click .toggle-select": () ->
		inst = Template.instance()
		context = inst.data

		on_value = 1
		off_value = 0

		if context.on_value
			on_value = context.on_value

		if context.off_value
			off_value = context.off_value

		current_value = inst.find("#"+inst.id).checked
		value = if current_value then on_value else off_value

		set_form_value(context, value)

