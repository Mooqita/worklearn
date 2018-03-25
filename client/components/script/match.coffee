################################################################################
#
# Matching Components
#
################################################################################

################################################################################
# helper functions
################################################################################

################################################################################
_has_doc = (context) ->
	data = context.data

	if not data.collection_name
		return false

	if not data.item_id
		return false

	if not data.field
		return false

	return true

################################################################################
# Button to find matches
################################################################################

################################################################################
Template.match_button.onCreated () ->
	self = this

	self.matching = new ReactiveVar(false)
	self.concepts = new ReactiveVar([])

	self.autorun () ->
		item_id = self.data.item_id

		if not _has_doc(self)
			text = get_value_from_context(self)
			item_id = fast_hash(text)

		parameter =
			page: 0
			size: 100
			item_id: item_id

		self.subscribe("my_matches", parameter)


################################################################################
Template.match_button.helpers
	match_disabled: () ->
		if Template.instance().matching.get()
			return "disabled"
		return ""

	is_matching: () ->
		return Template.instance().matching.get()


################################################################################
Template.match_button.events
	"click #match":(event)->
		if event.target.attributes.disabled
			return

		context = Template.instance()
		context.matching.set true
		data = context.data
		value = get_value_from_context(context)

		collection_name = data.collection_name
		item_id = data.item_id
		field = data.field

		in_collection = data.in_collection
		in_field = data.in_field

		handle = (err, res)->
			context.matching.set false
			if err
				sAlert.error(err)
				return
			context.subscribe("active_nlp_task", res.match_id)

		if not _has_doc(context)
			Meteor.call "match_text", value, in_collection, in_field, handle
			return

		Meteor.call "match_document", collection_name, item_id, field,
																	in_collection, in_field, handle


################################################################################
# Match concepts as tags
################################################################################

################################################################################
Template.match_tags.onCreated () ->
	self = this
	self.concepts = new ReactiveVar([])

	self.autorun () ->
		item_id = self.data.item_id

		if not _has_doc(self)
			text = get_value_from_context(self)
			item_id = fast_hash(text)

		parameter =
			page: 0
			size: 100
			item_id: item_id

		self.subscribe("my_matches", parameter)


################################################################################
Template.match_tags.helpers
	tasks: () ->
		return NLPTasks.find().count()>0

	n_matches: () ->
		return Matches.find().count()

	has_concepts: () ->
		return Matches.find().count()>0

	concepts: () ->
		context = Template.instance()
		data = context.data

		res = new Set()
		for m in Matches.find().fetch()
			for c in m.c
				res.add(c)

		if _has_doc(context)
			item_id = data.item_id
			collection = get_collection(data.collection_name)
			item = collection.findOne(item_id)

			if item.concepts
				for c in item.concepts
					res.add(c)

		concepts = Array.from(res)
		context.concepts.set(concepts)

		return concepts

	n_concepts: () ->
		context = Template.instance()
		concepts = context.concepts.get()

		return concepts.length

	drop_function: () ->
		context = Template.instance()
		data = context.data
		item_id = data.item_id

		if not _has_doc(context)
			text = get_value_from_context(context)
			item_id = fast_hash(text)

		o =
			func: (x) ->
				concept = x.data.label
				collection_name = data.collection_name
				Meteor.call "remove_concept_from_matches", concept, collection_name, item_id

		return o


################################################################################
Template.match_tags.events
	"change #new_tag":(event)->
		context = Template.instance()
		data = context.data

		context.matching.set true

		concept = event.target.value
		collection_name = data.collection_name
		item_id = context.item_id.get()

		Meteor.call "add_concept", concept, collection_name, item_id,
			(err, res)->
				context.matching.set false
				if err
					sAlert.error(err)
					return
				context.subscribe("active_nlp_task", res.match_id)


