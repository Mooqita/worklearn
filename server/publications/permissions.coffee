#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
Meteor.publish "permissions", () ->
	user_id = this.userId
	if !user_id
		throw new Meteor.Error "Not permitted."

	if !Roles.userIsInRole user_id, "admin"
		throw new Meteor.Error "Not permitted."

	crs = Permissions.find()
	log_publication "Permissions", crs, {}, {}, "permissions", user_id
	return crs

