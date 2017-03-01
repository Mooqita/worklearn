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

	"click #add_template": () ->
		self = this

		Meteor.call "add_template",
			(err, res) ->
				if err
					sAlert.error(err)
				else
					sAlert.info("Template added")
					Meteor.call "set_field", "Challenges", "template_id", self._id, res,
						(err, res) ->
							if err
								sAlert.error(err)
							else
								sAlert.success("Challenge set")

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

###################################################
#
# Editor
#
###################################################

###################################################
Template.challenge_editor.onCreated ->
	id = FlowRouter.getParam("challenge_id")
	challenge = Challenges.findOne(id)
	tn = challenge.template_id
	Session.set "current_template", tn

###################################################
Template.challenge_editor.helpers
	templates: () ->
		res = find_template_names()
		return res

	template: () ->
		tn = Session.get "current_template"
		return Templates.find tn

