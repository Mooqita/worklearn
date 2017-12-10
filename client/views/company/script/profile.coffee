########################################
Template.company_profile.onCreated ->
	this.parameter = new ReactiveDict()
	this.parameter.set "item_id", get_profile()._id
	this.parameter.set "collection_name", "profiles"


########################################
Template.company_profile.helpers
	parameter: () ->
		return Template.instance().parameter

########################################
Template.company_profile.events
	"click #add_member": (event) ->
		mails = Template.instance().find("#mails").value
		profile = get_profile()
		mails =
			email: mails
			role: "owner"

		Meteor.call "add_admissions", "profiles", profile._id, [mails],
			(res, err) ->
				if err
					sAlert.error(err)
				else
					sAlert.success("Invitation send.")

