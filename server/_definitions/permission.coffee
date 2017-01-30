###########################################################
#
# Created by Markus on 15/11/2015.
#
###########################################################

##############################################
class Permission
	constructor: (@role, @collection, @field, @action) ->
		@updatedAt = new Date()
		@createdAt = new Date()