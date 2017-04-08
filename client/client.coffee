#######################################################
#Created by Markus on 23/10/2015.
#Client
#######################################################

#Accounts.ui.config()

#worklearn
#TODO: move hash generation to server.
#TODO: template editor is not loading template code properly.
#TODO: make unique fields

#TODO: Students:Create profile
#TODO: Students:Link code revisions
#TODO: Students:give/receive reviews
#TODO: Students:Get credit

#TODO Companies: See profiles and credits
#TODO Companies: See details/code links is privileged access
#TODO All elements should be links not internal switches using: ?view=profile
#TODO Change color based on Text and or based on typing style

#Learning materials!!!!! I think we need to offer online classes that allow humans to code/write/design for the first time! Give credits to students for creating content?

given =
	_id: "given_name"
	type: "text"
	displayName: "Given name"
	required: true
	func: (name) ->
		if (Meteor.isServer)
			if name != ""
        return false # No error!
			return true # Validation error!
	errStr: 'Please enter your given name'

family =
	_id: "family_name"
	type: "text"
	displayName: "Family name"
	required: true
	func: (name) ->
		if (Meteor.isServer)
			if name != ""
        return false # No error!
			return true # Validation error!
	errStr: 'Please enter your family name'

AccountsTemplates.addFields([given, family])



