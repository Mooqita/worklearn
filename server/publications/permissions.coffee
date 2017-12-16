#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
Meteor.publish "permissions", () ->
	user_id = this.userId
	if not user_id
		throw new Meteor.Error "Not permitted."

	if not has_role Permissions, WILDCARD, ADMIN
		throw new Meteor.Error "Not permitted."

	crs = Permissions.find()
	log_publication crs, user_id, "permissions"
	return crs

