#######################################################
#
#Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
@Secrets = new Mongo.Collection("secrets")
@Logging = new Mongo.Collection("logging")
@DBFiles = new Mongo.Collection("dbfiles")

#######################################################
@PredaidTasks = new Mongo.Collection("predaid_tasks")

