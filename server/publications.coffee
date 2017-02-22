#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
Meteor.publish "challenges", () ->
	if !this.userId
		throw new Meteor.Error('Not permitted.')

	filter =
		owner_id: this.userId

	options =
		fields:
			name: 1

	crs = Challenges.find filter, options
	console.log('Challenge indices: ' + crs.count() + ' submitted!')
	return crs


#######################################################
Meteor.publish "challenge_by_id", (challenge_id) ->
	check challenge_id, String

	if !this.userId
		throw new Meteor.Error('Not permitted.')

	filter =
		owner_id: this.userId
		_id: challenge_id

	crs = Challenges.find filter
	console.log('Challenges: ' + crs.count() + ' submitted!')
	return crs


#######################################################
Meteor.publish "challenge_template", (challenge_id) ->
	check challenge_id, String

	if !this.userId
		throw new Meteor.Error('Not permitted.')

	filter =
		_id: challenge_id

	mod =
		fields:
			name: 1
			template: 1

	crs = Challenges.find filter, mod
	console.log('Challenge templates: ' + crs.count() + ' submitted!')
	return crs


#######################################################
Meteor.publish "response", (challenge_template, index) ->
	check challenge_template, String
	check index, String

	if !this.userId
		throw new Meteor.Error('Not permitted.')

	filter =
		challenge_template: challenge_template
		owner_id: this.userId
		index: index

	crs = Responses.find filter
	console.log('Responses: ' + crs.count() + ' submitted!')
	return crs


#######################################################
Meteor.publish "posts", (group_name) ->
	check group_name, Match.OneOf String, undefined, null

	filters = []
	roles = ['all']

	if this.userId
		# find all user roles
		roles.push 'anonymous'
		user = Meteor.users.findOne this.userId
		roles.push user.roles ...

		# adding a filter for all posts we authored
		f2 =
			#post_group: group_name
			owner_id: user._id

		filters.push f2

	# adding a filter for all posts our current role allows us to see
	f1 =
		post_group: group_name
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

#######################################################
Meteor.publish "permissions", () ->
	if !this.userId
		throw new Meteor.Error('Not permitted.')

	if !Roles.userIsInRole(this.userId, 'admin')
		throw new Meteor.Error('Not permitted.')

	crs = Permissions.find()
	console.log('Permissions: ' + crs.count() + ' submitted!')
	return crs


