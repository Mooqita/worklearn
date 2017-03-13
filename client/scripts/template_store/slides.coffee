#####################################################
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
		Meteor.call "add_response", "slide_content", index, this._id


##############################################
#
# Voting slides
#
##############################################

##############################################
Template.voting_booth_berlin_udk.events
	"click .option": () ->
		item_id = this._id
		Meteor.call "set_field", "Responses", item_id, "vote", event.target.id

##############################################
Template.voting_summary.onCreated ->
	for value in this.data.values
		Meteor.subscribe "sum_of_field", this.data.voting, this.data.field, value

##############################################
Template.voting_summary.helpers
	summary: ()->
		return Summaries.find()


##############################################
#
# Fullscreen slides
#
##############################################

target = undefined

get_next_slide = () ->
	r_id = Session.get "current_slide_id"
	cur = Responses.findOne r_id
	if not cur
		return

	s_id = Session.get "current_slide_index"
	if not s_id
		s_id = cur.index

	filter =
		index: s_id + 1
		parent_id: cur.parent_id

	res = Responses.findOne filter
	return res

set_next_slide = () ->
	slide = get_next_slide()

	if slide
		Session.set "current_slide_id", slide._id
		Session.set "current_slide_index", slide.index
	else
		s_id = Session.get "current_slide_index"
		Session.set "current_slide_index", s_id + 1

#######################################################
Template.full_screen.onCreated () ->
	document.addEventListener "keyup",
		(event) ->
			if event.code == "Escape"
				Session.set "full_screen", false
			if event.code == "Space"
				if Session.get "full_screen"
					set_next_slide()

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

