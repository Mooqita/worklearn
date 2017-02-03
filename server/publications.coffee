#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
Meteor.publish "posts", (template_name) ->
	check template_name, String

	filters = []
	roles = ['all']

	if this.userId
		# find all user roles
		roles.push 'anonymous'
		user = Meteor.users.findOne this.userId
		roles.push user.roles ...

		# adding a filter for all posts we authored
		f2 =
			template: template_name
			owner_id: user._id

		filters.push f2

	# adding a filter for all posts our current role allows us to see
	f1 =
		template: template_name
		deleted:
			$ne:
				true
		visible_to:
			$in: roles
	filters.push f1

	filter =
		$or: filters

	mod =
		fields:
			paper: 0

	self = this

	handler =
		added: (id) ->
			item = Posts.findOne(id)
			if item.paper
				item['paper_url'] = '/file/Posts/' + item._id + '/paper/' + item.title
			self.added('posts', item._id, item)
			console.log('Post of ' + item.template + ' added: ' + id)

		changed: (id) ->
			item = Posts.findOne(id)
			if item.paper
				item['paper_url'] = '/file/Posts/' + item._id + '/paper/' + item.title
			self.changed('posts', item._id, item)
			console.log('Post ' + item.template + ' changed: ' + id)

		removed: (id) ->
			self.removed("posts", id)
			console.log('Post ' + item.template + ' removed: ' + id)

	handle = Posts.find(filter, mod).observeChanges(handler)

	self.ready()
	self.onStop () ->
    handle.stop()

#######################################################
Meteor.publish "files", (collection_name, item_id, field) ->
	__deny_publish(collection_name, item_id, field, this.userId)

	colllection = get_collection collection_name
	data =
		data: colllection.findOne(item_id)[field]

	this.added('files', Random.id(), data)
	console.log('File: '+collection_name+"."+field+' submitted!')

