#######################################################
#Created by Markus on 23/10/2015.
#######################################################

#######################################################
# Moocita
#######################################################

#######################################################
@Permissions = new Mongo.Collection("permissions")
@Templates = new Mongo.Collection("templates")
@Responses = new Mongo.Collection("responses")
@Summaries = new Mongo.Collection("summaries")

#######################################################
@User_Credentials = new Mongo.Collection("user_credentials")
@Challenge_Summary = new Mongo.Collection("challenge_summary")

#######################################################
@Admin = new Mongo.Collection("admin")
@Tasks = new Mongo.Collection("tasks")
@Files = new Mongo.Collection("files")

