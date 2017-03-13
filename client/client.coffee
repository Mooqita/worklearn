#######################################################
#Created by Markus on 23/10/2015.
#Client
#######################################################

#Accounts.ui.config()

#worklearn
#TODO: move hash generation to server.
#TODO: template editor is not loading template code properly.
#TODO: make unique fieelds


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

