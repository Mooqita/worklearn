#############################################################
# functions
#############################################################

#############################################################
_split_tags = (tag_line) ->
	tags_in = tag_line.split ","
	tags = {}
	for tag in tags_in
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
_meteor_tag = (self, event, value) ->
	field = self.field
	method = self.method
	collection = self.collection_name
	item_id = self.item_id

	Meteor.call method, collection, item_id, field, value, undefined,
		(err, res) ->
			if err
				sAlert.error "Tags input error: " + err
				console.log err
			if res
				sAlert.success "Updated: " + field


#############################################################
Template.tags.onCreated ->


#########################################################
Template.tags.events
	"change .edit-field": (event) ->
		data = Template.instance().data
		value = get_field_value data
		old_tags = _split_tags value

		new_tags = _split_tags event.target.value
		value = _update_tags old_tags, new_tags

		_meteor_tag data, event, value

	"change .tags": (event) ->
		instance = Template.instance()
		data = instance.data
		value = get_field_value instance.data
		old_tags = _split_tags value

		target = event.target
		selected = target.options[target.selectedIndex]
		new_tag = {"label": this.label, "level": selected.value}

		value = _update_tag old_tags, new_tag

		_meteor_tag data, event, value


#############################################################
Template.tags.helpers
	clean: () ->
		value = get_field_value Template.instance().data
		return value

	tag_line: () ->
		value = get_field_value Template.instance().data
		tags = _split_tags value
		keys = Object.keys tags

		return keys.join ",", keys

	tags: () ->
		data = Template.instance().data
		options = data.rating_options
		value = get_field_value data
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

