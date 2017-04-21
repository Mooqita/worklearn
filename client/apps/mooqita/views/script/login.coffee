##########################################################
# First time user
##########################################################

##########################################################
_add_profile = (occupation) ->
	filter =
		owner_id: Meteor.userId()
		type_identifier: "profile"

	profile = Responses.findOne filter

	if profile
		Meteor.call "set_field", "Responses", profile._id, "occupation", occupation
		Meteor.call "set_field", "Responses", profile._id, "has_occupation", true
		return

	index = Responses.find(filter).count()

	param =
		name: "profile: " + index
		index: index
		template_id: "profile"
		type_identifier: "profile"
		occupation: occupation
		has_occupation: true

	Meteor.call "add_response", param,
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