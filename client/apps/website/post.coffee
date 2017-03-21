#########################################################
# Post
#########################################################

#########################################################
Template._post.helpers
	children: (parent) ->
		filter =
			parent_id: parent._id

		mod =
			sort:
				index:1

		list = Responses.find(filter, mod)
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

		list = Responses.find(filter, mod).fetch()
		groups = [{value:"", label:"Select a parent"}]
		groups.push ({value:x._id, label:x.title} for x in list)...

		return groups

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

