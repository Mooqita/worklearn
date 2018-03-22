#######################################################
#
# Created by Markus
#
#######################################################

#######################################################
_get_document = (collection_name, item_id, field) ->
	collection = get_collection(collection_name)
	item = collection.findOne(item_id)
	return item[field]


################################################################
Meteor.methods
	match_document: (collection_name, item_id, field, in_collection, in_field) ->
		user = Meteor.user()
		if not user
			throw new Meteor.Error("Not permitted")

		check item_id, String
		check field, String
		check in_collection, String
		check in_field, String

		collection = get_collection(collection_name)
		item = collection.findOne(item_id)
		if not can_edit(collection, item, user)
			throw new Meteor.Error("Not permitted")

		if not item.published
			modify_field_unprotected(collection, item_id, "published", true)

		filter =
			ids: item_id
		Matches.remove(filter)

		add_id = handle_text(collection_name, item_id, field, user)
		match_id = match_text(collection_name, item_id, field, user)
		modify_field_unprotected(collection, item_id, "matched", true)

		res =
			add_id: add_id
			match_id: match_id

		return res


	add_concept: (concept, collection_name, item_id) ->
		user = Meteor.user()
		if not user
			throw new Meteor.Error("Not permitted")

		check item_id, String
		check concept, String
		check collection_name, String

		if concept == ""
			return false

		collection = get_collection(collection_name)
		csn = can_edit collection, item_id, user

		if not csn
			throw new Meteor.Error "Not permitted."

		filter = {_id: concept}
		mod =
			$push:
				vote:
					user_id: user._id
					rating: 1
		Concepts.upsert(filter, mod, )

		collection.update(item_id, {$addToSet: {concepts:concept}})
		add_id = handle_text(collection, item_id, "concepts", user)
		match_id = match_text(collection_name, item_id, "concepts", user)

		res =
			add_id: add_id
			match_id: match_id

		return res


	remove_concept_from_matches: (concept, collection_name, item_id) ->
		user = Meteor.user()
		if not user
			throw new Meteor.Error("Not permitted")

		check item_id, String
		check concept, String
		check collection_name, String

		collection = get_collection(collection_name)
		csn = can_edit collection, item_id, user

		if not csn
			throw new Meteor.Error "Not permitted."

		filter =
			ids: item_id

		mod =
			$pull: {c: concept}

		Matches.update(filter, mod, {multi: true})

		filter.c = { $size : 0 }
		Matches.remove(filter)

		filter = {_id: concept}
		mod =
			$push:
				vote:
					user_id: user._id
					rating: -1
		Concepts.update(filter, mod)

		collection.update(item_id, {$pull: {concepts:concept}})
		return true


	documents_from_match: (match_id) ->
		match = Matches.findOne(match_id)

		a = _get_document(match.ca, match.ids[0], match.fa)
		b = _get_document(match.cb, match.ids[1], match.fb)
		user_a = "a"
		user_b = "b"

		return [a, b, user_a, user_b]