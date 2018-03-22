#############################################################
# functions
#############################################################

#############################################################
_get_value = (template_instance) ->
	value = get_field_value template_instance.data
	if not value
		value = template_instance.tag_data.get()

	return value


#############################################################
_split_tags = (tag_line) ->
	tags_in = tag_line.split ","
	tags = {}
	for tag in tags_in
		if tag == ""
			continue
		el = tag.split ":"
		tags[el[0]] = el[1] | 0

	return tags


#############################################################
_update_tags = (old_tags, new_tags) ->
	res = []
	for tag, level of new_tags
		res.push(tag + ":" + (level | old_tags[tag]))

	return res.join ","


#############################################################
_update_tag = (old_tags, new_tag) ->
	res = []
	for tag, level of old_tags
		if tag == new_tag.label
			level = new_tag.level
		res.push tag + ":" + level

	return res.join ","


#############################################################
_set_value = (template_instance, event, value) ->
	self = template_instance.data
	old = get_field_value self
	if not old
		template_instance.tag_data.set value
		return

	field = self.field
	collection = self.collection_name
	item_id = self.item_id

	set_field collection, item_id, field, value


#############################################################
Template.tags.onCreated ->
	this.tag_data = new ReactiveVar("")


#########################################################
Template.tags.events
	"change .edit-field": (event) ->
		instance = Template.instance()
		value = _get_value instance
		old_tags = _split_tags value

		new_tags = _split_tags event.target.value
		value = _update_tags old_tags, new_tags

		_set_value instance, event, value

	"change .tags": (event) ->
		instance = Template.instance()
		value = _get_value instance
		old_tags = _split_tags value

		target = event.target
		selected = target.options[target.selectedIndex]
		new_tag = {"label": this.label, "level": selected.value}

		value = _update_tag old_tags, new_tag

		_set_value instance, event, value


#############################################################
Template.tags.helpers
	clean: () ->
		value = _get_value Template.instance()
		return value

	tag_line: () ->
		value = _get_value Template.instance()
		tags = _split_tags value
		keys = Object.keys tags

		return keys.join ",", keys

	tags: () ->
		instance = Template.instance()
		options = instance.data.rating_options
		value = _get_value instance
		tags = _split_tags value

		if not options
			options = [
				{label:"not selected", value:0},
				{label:"basic", value:1},
				{label:"intermediate", value:2},
				{label:"advanced", value:3},
				{label:"expert", value:4}]

		keys = ({"label":key, "level":value, "options":options} for key, value of tags)

		return keys


#############################################################
# Tag
#############################################################

#############################################################
Template.tag.helpers
	options: ()->
		opt = Template.instance().data.options
		return opt

	is_selected: (val) ->
		data = Template.instance().data

		if String(val) == String(data.level)
			return "selected"

		return ""

	drop_style: () ->
		inst = Template.instance()
		if "drop_function" of inst.data
			return "padding-right:25px;"
		return ""

#############################################################
Template.tag.events
	"click #drop":()->
		inst = Template.instance()
		inst.data.drop_function.func(inst)
