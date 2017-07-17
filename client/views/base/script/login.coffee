##########################################################
_add_profile = (occupation) ->
	param =
		occupation: occupation

	Meteor.call "add_profile", param,
		(err) ->
			if err
				sAlert.error(err)


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
	"click #student": () ->
		if Template.instance().adding_profile.get()
			return

		Template.instance().adding_profile.set true
		_add_profile("student")

	"click #teacher": () ->
		if Template.instance().adding_profile.get()
			return

		Template.instance().adding_profile.set true
		_add_profile("teacher")

	"click #company": () ->
		if Template.instance().adding_profile.get()
			return

		Template.instance().adding_profile.set true
		_add_profile("company")