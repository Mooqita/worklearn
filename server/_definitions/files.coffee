###########################################################
#
# Created by Markus on 15/11/2015.
#
###########################################################

class @DBFile
	constructor: (@data, @type, @collection, @set_id) ->
		@size = data.length()
		@createdAt = new Date()
		@updatedAt = new Date()
		@owner_id = Meteor.userId()