#####################################################
# start up
#####################################################
Meteor.startup () ->
	index =
		owner_id: 1
	Challenges._ensureIndex index
	Solutions._ensureIndex index
	Reviews._ensureIndex index
	Feedback._ensureIndex index
	Profiles._ensureIndex index
	Messages._ensureIndex index
	Posts._ensureIndex index

	index =
		parent_id: 1
	Challenges._ensureIndex index
	Solutions._ensureIndex index
	Reviews._ensureIndex index
	Feedback._ensureIndex index
	Profiles._ensureIndex index
	Posts._ensureIndex index

	index =
		text_index: "text"
		type_identifier: 1
	Challenges._ensureIndex index
	Solutions._ensureIndex index
	Reviews._ensureIndex index
	Feedback._ensureIndex index
	Posts._ensureIndex index
