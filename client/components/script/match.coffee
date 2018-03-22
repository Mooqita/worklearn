################################################################################
#
# Matching Components
#
################################################################################

################################################################################
# Button to find matches
################################################################################

################################################################################
Template.match_button.onCreated () ->
	self = this
	self.matching = new ReactiveVar(false)
	self.concepts = new ReactiveVar([])

	self.parameter =
		page: 0
		size: 100
		item_id: self.data.item_id

	self.autorun () ->
		self.subscribe("my_matches", self.parameter)


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
		data = inst.data

		collection_name = data.collection_name
		item_id = data.item_id
		field = data.field

		in_collection = data.in_collection
		in_field = data.in_field

		Meteor.call "match_document", collection_name, item_id, field, in_collection, in_field,
			(err, res)->
				inst.matching.set false
				if err
					sAlert.error(err)
					return
				inst.subscribe("active_nlp_task", res.match_id)


################################################################################
# Match concepts as tags
################################################################################

################################################################################
Template.match_tags.onCreated () ->
	self = this
	self.concepts = new ReactiveVar([])

	self.parameter =
		page: 0
		size: 100
		item_id: self.data.item_id

	self.autorun () ->
		self.subscribe("my_matches", self.parameter)


################################################################################
Template.match_tags.helpers
	tasks: () ->
		return NLPTasks.find().count()>0

	n_matches: () ->
		return Matches.find().count()

	has_concepts: () ->
		return Matches.find().count()>0

	concepts: () ->
		inst = Template.instance()
		data = inst.data

		res = new Set()
		for m in Matches.find().fetch()
			for c in m.c
				res.add(c)

		item_id = data.item_id
		collection = get_collection(data.collection_name)
		item = collection.findOne(item_id)
		if item.concepts
			for c in item.concepts
				res.add(c)

		inst = Template.instance()
		concepts = Array.from(res)
		inst.concepts.set(concepts)

		return concepts

	n_concepts: () ->
		inst = Template.instance()
		concepts = inst.concepts.get()

		return concepts.length

	drop_function: () ->
		inst = Template.instance()
		data = inst.data
		item_id = data.item_id

		o =
			func: (x) ->
				concept = x.data.label
				collection_name = data.collection_name
				Meteor.call "remove_concept_from_matches", concept, collection_name, item_id

		return o


################################################################################
Template.match_tags.events
	"change #new_tag":(event)->
		inst = Template.instance()
		data = inst.data

		inst.matching.set true

		concept = event.target.value
		collection_name = data.collection_name
		item_id = data.item_id

		Meteor.call "add_concept", concept, collection_name, item_id,
			(err, res)->
				inst.matching.set false
				if err
					sAlert.error(err)
					return
				inst.subscribe("active_nlp_task", res.match_id)


