##############################################
#
# Fullscreen slides
#
##############################################

##############################################
target = undefined

##############################################
get_slide = (diff) ->
	r_id = Session.get "current_slide_id"
	cur = Responses.findOne r_id
	if not cur
		return

	s_id = Session.get "current_slide_index"
	if not s_id
		s_id = cur.index

	filter =
		index: s_id + diff
		parent_id: cur.parent_id

	res = Responses.findOne filter
	return res

##############################################
get_next_slide = () ->
	return get_slide(1)

##############################################
get_previous_slide = () ->
	return get_slide(-1)

##############################################
set_slide = (diff) ->
	slide = get_slide(diff)

	if slide
		Session.set "current_slide_id", slide._id
		Session.set "current_slide_index", slide.index
	else
		s_id = Session.get "current_slide_index"
		Session.set "current_slide_index", s_id + diff

##############################################
set_next_slide = () ->
	return set_slide(1)

##############################################
set_previous_slide = () ->
	return set_slide(-1)

#######################################################
Template.full_screen.onCreated () ->
	document.addEventListener "keyup",
		(event) ->
			cr = event.ctrlKey == true
			fs = if Session.get "full_screen" then true else false

			if event.code == "Escape"
				Session.set "full_screen", false
			if event.code == "Space"
				if cr or fs
					set_next_slide()
			if event.code == "Backspace"
				if cr or fs
					set_previous_slide()

	$(document).on 'webkitfullscreenchange mozfullscreenchange fullscreenchange',
		(event) ->
			if not (RunPrefixMethod(document, "FullScreen") || RunPrefixMethod(document, "IsFullScreen"))
				Session.set "full_screen", false


#######################################################
Template.full_screen.events
	"click #make_full_screen": () ->
		target = $("#full_screen")[0]

		id = Session.get "current_slide_id"
		slide = Responses.findOne id
		Session.set "current_slide_index", slide.index

		if (RunPrefixMethod(document, "FullScreen") || RunPrefixMethod(document, "IsFullScreen"))
			RunPrefixMethod(document, "CancelFullScreen")
			Session.set "full_screen", false
		else
			RunPrefixMethod(target, "RequestFullScreen")
			Session.set "full_screen", true


#####################################################
#
# Slide deck
#
#####################################################

#####################################################
Template.slide_deck.onCreated ->
	Session.set "current_slide_id", ""

#####################################################
Template.slide_deck.helpers
	children: (parent) ->
		filter =
			parent_id: parent._id

		mod =
			sort:
				index:1

		list = Responses.find(filter, mod)
		return list

	current_slide: () ->
		id = Session.get "current_slide_id"
		slide = Responses.findOne(id)

		if slide
			slide['current'] = true

		return slide


#####################################################
Template.slide_deck.events
	"click #slide": () ->
		Session.set "current_slide_id", this._id

	"click #go_back": () ->
		Session.set "current_slide_id", ""

	"click #add_slide": () ->
		filter =
			parent_id: this._id

		index = Responses.find(filter).count()

		param =
			index: index + 1
			parent_id: this._id
			template_id: "slide_content"
			single_parent: false
			type_identifier: "slide"

		Meteor.call "add_response", param,
			(err, res) ->
				if err
					sAlert.error(err)



##############################################
#
# Voting summary slides
#
##############################################

##############################################
Template.voting_summary.onCreated ->
	for value in this.data.values
		Meteor.subscribe "sum_of_field", this.data.voting, this.data.field, value

##############################################
Template.voting_summary.helpers
	summary: ()->
		return Summaries.find()

##############################################
Template.voting_summary.events
	"click #url": ()->
		filter=
			name: this._id
		res = Responses.findOne(filter)
		Session.set "current_slide_id", res._id

##############################################
#
# Voting booth
#
##############################################

##############################################
Template.udk.events
	"click .option": () ->
		item_id = this._id
		Meteor.call "set_field", "Responses", item_id, "vote", event.target.id

