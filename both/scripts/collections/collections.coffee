#######################################################
#Created by Markus on 23/10/2015.
#######################################################

#######################################################
# Moocita
#######################################################

#######################################################
@Templates = new Mongo.Collection("templates")
@Posts = new Mongo.Collection("posts")
@Files = new Mongo.Collection("files")

#######################################################
@Permissions = new Mongo.Collection("permissions")
@Challenges = new Mongo.Collection("challenges")
@Responses = new Mongo.Collection("responses")

#######################################################
@Admin = new Mongo.Collection("admin")

