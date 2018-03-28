#########################################################
# Post
#########################################################

#######################################################
Template.registerHelper "post_can_edit", (collection_name, item_id) ->
	collection = get_collection collection_name
	user_id = Meteor.userId()
	item = collection.findOne(item_id)
	owns = can_edit collection_name, item, user_id
	return owns


######################################################
Template.registerHelper "post_is_editing", (item_id) ->
	is_ed = item_id == Session.get("editing_response")
	return is_ed


#########################################################
# Post group
#########################################################

#########################################################
Template.post_group.onCreated ->
	self = this
	self.autorun () ->
		self.subscribe "posts", self.data.group_name

#########################################################
Template.post_group.helpers
	templates: () ->
		return [{value:"", label:"Select template"}
		{value:"empty", label:"Empty"}
		{value:"post", label:"Post"}
		{value:"headline", label:"Headline"}
		{value:"publication", label:"Publication"}
		{value:"team", label:"Team"}
		{value:"member", label:"Member"}
		{value:"partner", label:"Partner"}
		{value:"partner_list", label:"Partner List"}]

	groups: () ->
		filter =
			parent_id: ""
			group_name: this.group_name

		mod =
			sort:
				index: 1
				view_order: 1

		return Posts.find(filter, mod)

#########################################################
Template.post_group.events
	'click #add_post': ()->
		e = $('#template_select')[0]
		val = e.options[e.selectedIndex].value
		val = if not val then "post" else val

		filter =
			parent_id: this._id

		index = Posts.find(filter).count()

		index = index + 1
		group_name = this.group_name

		parent_id = this._id
		template_id = val

		Meteor.call 'add_post', template_id, parent_id, group_name, index,
			(err, res) ->
				if err
					sAlert.error("Add post error: " + err)


#########################################################
# Post entry
#########################################################

#########################################################
Template._post.helpers
	children: ->

		filter =
			parent_id: this.data._id

		mod =
			sort:
				index:1

		list = Posts.find(filter, mod)
		return list


#########################################################
# Edit tools
#########################################################

#########################################################
Template._edit_toggle.events
	'click #edit': () ->
		ed = Session.get("editing_response")

		if ed == this._id
			Session.set("editing_response", "")
			return

		Session.set("editing_response", this._id)


#########################################################
Template._edit_tools.helpers
	is_visible: (val) ->
		if val in this.visible_to
			return "selected"

	is_template: (val) ->
		if val == this.template
			return "selected"

	is_group: (val) ->
		if val == this.group
			return "selected"

	templates: () ->
		return [{value:"", label:"Select template"}
		{value:"empty", label:"Empty"}
		{value:"post", label:"Post"}
		{value:"headline", label:"Headline"}
		{value:"publication", label:"Publication"}
		{value:"team", label:"Team"}
		{value:"member", label:"Member"}
		{value:"partner", label:"Partner"}
		{value:"partner_list", label:"Partner List"}]

	parents: () ->
		filter = {}
		mod =
			fields:
				_id: 1
				title: 1

		collection = get_collection this.collection_name
		if not collection
			return []

		list = collection.find(filter, mod).fetch()
		groups = [{value:"", label:"Select a parent"}]
		groups.push ({value:x._id, label:x.title} for x in list)...

		return groups

