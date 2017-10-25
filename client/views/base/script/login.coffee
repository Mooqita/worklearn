import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

##########################################################
_add_profile = (occupation) ->
	param =
		occupation: occupation

	Meteor.call "add_profile", param,
		(err) ->
			if err
				sAlert.error("Likert item error: " + err)
			# Onboarding does not yet exist for educator/company
			else if param.occupation is "learner"
				FlowRouter.go "/onboarding/context/"

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