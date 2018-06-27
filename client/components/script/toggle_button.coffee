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

		if value == 1
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

		value = if inst.find("#"+inst.id).checked then 1 else 0

		set_form_value(context, value)

