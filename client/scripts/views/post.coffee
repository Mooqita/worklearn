#########################################################
# Post
#########################################################

#########################################################
Template._post.events
	'click #remove_post': ()->
		Meteor.call 'set_post_field', '', this._id, 'deleted', true, undefined,
			(err, res) ->
				if err
					sAlert.error(err)

	'click #reinstate_post': ()->
		Meteor.call 'set_post_field', '', this._id, 'deleted', false, undefined,
			(err, res) ->
				if err
					sAlert.error(err)

	'click #edit': () ->
		ed = Session.get("editing_post")

		if ed == this._id
			Session.set("editing_post", "")
			return

		Session.set("editing_post", this._id)

#########################################################
Template._post.helpers
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
		opts = [
			{value:"", label:"Use template"}
			{value:"empty", label:"Empty"}
			{value:"post", label:"Post"}
			{value:"headline", label:"Headline"}
			{value:"publication", label:"Publication"}]
		return opts

	visibility: () ->
		opts = [
			{value:"", label:"Who can read your post"}
			{value:"all", label:"Everyone"}
			{value:"anonymous", label:"Registered Users"}
			{value:"owner", label:"Only me"}]
		return opts


#########################################################
# Paper
#########################################################

#########################################################
Template.publication.events
	'click #remove_paper': (event) ->
		Meteor.call 'set_post_field', '', this._id, 'paper', '', undefined,
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.success('Paper cleared')

	'click #remove_figure': (event) ->
		Meteor.call 'set_post_field', '', this._id, 'figure', '', undefined,
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
		Meteor.call 'set_post_field', '', this._id, 'figure', '', undefined,
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
