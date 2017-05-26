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
		solution_id: 1
	Reviews._ensureIndex index
	Feedback._ensureIndex index

	index =
		content: "text"
		title: "text"
	Challenges._ensureIndex index
	Solutions._ensureIndex index
	Reviews._ensureIndex index
	Feedback._ensureIndex index
	Posts._ensureIndex index
