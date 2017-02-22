#import dragula from "dragula"

###################################################
#
# Dashboard for hit editing
#
###################################################

###################################################
Template.challenge_dashboard.onCreated ->
	self = this
	challenge_id = FlowRouter.getParam("challenge_id")

	self.autorun () ->
		if challenge_id
			self.subscribe "challenge_by_id", challenge_id
		else
			self.subscribe "challenges"

###################################################
Template.challenge_dashboard.events
	"click #add_challenge": () ->
		Meteor.call "add_challenge",
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.info("Challenge added")

###################################################
Template.challenge_dashboard.helpers
	challenge: () ->
		id = FlowRouter.getParam("challenge_id")
		res = Challenges.findOne(id)
		return res

	challenges: () ->
		return Challenges.find()

	challenge_url: () ->
		return "/challenge_dashboard/"+this._id


'''
###################################################
#
# Editor
#
###################################################

###################################################
Template.challenge_editor.onCreated ->
	self = this
	challenge_id = FlowRouter.getParam("challenge_id")

	self.autorun () ->
		self.subscribe "challenge_by_id", challenge_id

###################################################
Template.challenge_editor.onRendered ->
	elements =[
		document.querySelector("#component_container")
		document.querySelector("#challenge_container")]

	options =
		removeOnSpill: true

		copy: (el, source) ->
			expect = document.getElementById("component_container")
			copy = source.id == expect.id
			return copy

		moves: (el, container, handle) ->
			return container.id != "challenge_container"

		accepts: (el, target) ->
			expect = document.getElementById("challenge_container")
			accept = target.id == expect.id
			return accept

	drake = dragula(elements, options)

	drake.on "drop", (el) ->
		challenge_id = FlowRouter.getParam("challenge_id")
		challenge = Challenges.findOne(challenge_id)

		try
			obj = JSON.parse(challenge.content)
			obj.components.push({"template":el.id})

			item_id = FlowRouter.getParam("challenge_id")

			Meteor.call "set_field", "Challenges", item_id, "content", JSON.stringify(obj),
				(err, res)->
					if err
						sAlert.error(err)
					else
						sAlert.success("Field updated")

		catch error
			console.log error
			sAlert.error error

		el.remove()


###################################################
Template.challenge_editor.helpers
	components: () ->
		return [
			{id:"text_area_edit", label:"Text Area"}
			{id:"text_input_edit", label:"Text Input"}
			{id:"number_input_edit", label:"Number"}
			{id:"likert_edit", label:"Likert"}
			{id:"response_edit", label:"Response Code"}
			{id:"country_edit", label:"Country"}
			{id:"select_input_edit", label:"Select"}
			{id:"code_input_edit", label:"Code"}
			{id:"text",label:"Text"}
			{id:"header",label:"Head line"}
		]

	challenge_components: () ->
		challenge_id = FlowRouter.getParam("challenge_id")
		challenge = Challenges.findOne(challenge_id)

		if not challenge
			return []

		if not challenge.content
			return []

		obj = JSON.parse(challenge.content)
		return obj.components

	content: () ->
		challenge_id = FlowRouter.getParam("challenge_id")
		challenge = Challenges.findOne(challenge_id)

		if not challenge
			return undefined

		return challenge.content
'''