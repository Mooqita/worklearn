#########################################################
# Post
#########################################################

#########################################################
Template._post.helpers
	children: (parent) ->
		filter =
			parent: parent._id

		mod =
			sort:
				view_order:1

		list = Posts.find(filter, mod)
		return list


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
		return find_template_names()

	visibility: () ->
		opts = [
			{value:"", label:"Who can read your post"}
			{value:"all", label:"Everyone"}
			{value:"anonymous", label:"Registered Users"}
			{value:"owner", label:"Only me"}]
		return opts

	parents: () ->
		filter = {}
		mod =
			fields:
				_id: 1
				title: 1

		list = Posts.find(filter, mod).fetch()
		groups = [{value:"", label:"Select a parent"}]
		groups.push ({value:x._id, label:x.title} for x in list)...

		return groups


#########################################################
# Paper
#########################################################

#########################################################
Template.publication.events
	'click #remove_paper': (event) ->
		Meteor.call 'set_field', 'Posts', this._id, 'paper', '', undefined,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.success('Paper cleared')

	'click #remove_figure': (event) ->
		Meteor.call 'set_field', 'Posts', this._id, 'figure', '', undefined,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.success('Figure cleared')

#########################################################
# Post
#########################################################

#########################################################
Template.post.events
	'click #remove_figure': (event) ->
		Meteor.call 'set_field', 'Posts', this._id, 'figure', '', undefined,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.success('Figure cleared')

#########################################################
# Empty
#########################################################

#########################################################
# Headline
#########################################################

#########################################################
Template.headline.helpers
	letter: () ->
		words = this.title.split(' ')
		res = ""
		for w in words
			res += "<em>"+w[0]+"</em>"+w.substring(1)

		return res
