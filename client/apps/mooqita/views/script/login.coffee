##########################################################
# First time user
##########################################################

##########################################################
_add_profile = (occupation) ->
	param =
		occupation: occupation

	Meteor.call "add_profile", param,
		(err) ->
			if err
				sAlert.error(err)

##########################################################
Template.first_timer.onCreated ->

##########################################################
Template.first_timer.events
	"click #student": () ->
		_add_profile("student")

	"click #teacher": () ->
		_add_profile("teacher")

	"click #company": () ->
		_add_profile("company")