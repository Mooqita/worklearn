#######################################################
#Created by Markus on 23/10/2015.
#Client
#######################################################

#Accounts.ui.config()

#PREDAID
#TODO: distinguish between the reviews-that-I-wrote-averages and reviews-that-I-received-averages
#TODO: add author field!!!!
#TODO: add reviewer id
#TODO: UI indicator if paper has a comparison

#MOOCITA
#TODO: error handling using juliancwirko:s-alert package
#TODO: logout delete all local data
#TODO: Message when text is to short.
#TODO: Make sure that after publication no changes can be made but you can start a new solution

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

ShareIt.configure
	iconOnly: true
	applyColors: true
	faSize: ''
	faClass: ''
