#########################################################
# Post
#########################################################

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
					sAlert.error(err)


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
# Headline
#########################################################

#########################################################
Template.headline.helpers
	letter: () ->
		words = this.title.split(' ')
		res = ""
		for w in words
			res += "<em>"+w[0]+"</em>"+w.substring(1)+" "

		return res

