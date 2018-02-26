##########################################################
# local variables and methods
##########################################################

##########################################################
_add_profile = (occupation) ->
	param =
		occupation: occupation

	Meteor.call "add_profile", param,
		(err) ->
			if err
				sAlert.error("Likert item error: " + err)


##########################################################
# First time user
##########################################################

##########################################################
Template.first_timer.onCreated ->
	this.adding_profile = new ReactiveVar(false)


##########################################################
Template.first_timer.helpers
	select_disabled: ->
		if Template.instance().adding_profile.get()
			return "select-disabled"
		return ""


##########################################################
Template.first_timer.events
	"click #home": () ->


	"click #learner": () ->
		if Template.instance().adding_profile.get()
			return

		Template.instance().adding_profile.set true
		_add_profile("learner")

	"click #educator": () ->
		if Template.instance().adding_profile.get()
			return

		Template.instance().adding_profile.set true
		_add_profile("educator")

	"click #organization": () ->
		if Template.instance().adding_profile.get()
			return

		Template.instance().adding_profile.set true
		_add_profile("organization")