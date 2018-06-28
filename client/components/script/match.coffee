################################################################################
#
# Matching Components
#
################################################################################

################################################################################
# helper functions
################################################################################

################################################################################
@concepts_from_context = (context) ->
	context = Template.instance()
	data = context.data

	res = new Set()
	for m in Matches.find().fetch()
		for c in m.c
			res.add(c[0])

	if _has_doc(context)
		item_id = data.item_id
		collection = get_collection(data.collection_name)
		item = collection.findOne(item_id)

		if item.concepts
			for c in item.concepts
				res.add(c)

	concepts = Array.from(res)
	return concepts


################################################################################
_has_doc = (instance) ->
	data = instance.data

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
			text = get_form_value(self.data)
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

		inst = Template.instance()
		inst.matching.set true

		context = inst.data
		value = get_form_value(context)

		collection_name = context.collection_name
		item_id = context.item_id
		field = context.field

		in_collection = context.in_collection

		handle = (err, res)->
			inst.matching.set false
			if err
				sAlert.error(err)
				return
			if not res.match_id
				msg = "Hmm not yet."
				sAlert.warning(msg)
			else
				inst.subscribe("active_nlp_task", res.match_id)

		if not _has_doc(inst)
			Meteor.call "match_text", value, in_collection, handle
			return

		Meteor.call "match_document", collection_name, item_id, field,
																	in_collection, handle


################################################################################
# Match concepts as tags
################################################################################

################################################################################
Template.match_tags.onCreated () ->
	self = this
	self.concepts = new ReactiveVar([])
	self.matching = new ReactiveVar(false)

	self.autorun () ->
		item_id = self.data.item_id

		if not _has_doc(self)
			text = get_form_value(self)
			item_id = fast_hash(text)

		parameter =
			page: 0
			size: 100
			item_id: item_id

		self.subscribe("my_matches", parameter)


################################################################################
Template.match_tags.helpers
	tasks: () ->
		nlp_task = NLPTasks.findOne()
		if not nlp_task
			return false

		return not nlp_task.solved

	n_matches: () ->
		return Matches.find().count()

	has_concepts: () ->
		return Matches.find().count()>0

	concepts: () ->
		context = Template.instance()
		concepts = concepts_from_context(context)

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
			text = get_form_value(context)
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
		context.matching.set(true)

		data = context.data

		item_id = data.item_id
		concept = event.target.value
		collection_name = data.collection_name

		if not _has_doc(context)
			item_id = get_form_value(context)
			item_id = fast_hash(item_id)

		Meteor.call "add_concept", concept, collection_name, item_id,
			(err, res)->
				sAlert.warning("Found: " + res.found_concepts + " " + res.found_text)
				context.matching.set(false)

				if err
					sAlert.error(err)
					return

				if res.found == 0
					msg = "Sorry, my bad, I can not improve your results "
					msg += "using the concept: '" + concept + "'."
					sAlert.warning(msg)
				else
					context.subscribe("active_nlp_task", res.match_id)
