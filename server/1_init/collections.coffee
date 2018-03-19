#######################################################
#
# Created by Markus
#
#######################################################

#######################################################
@Secrets = new Mongo.Collection("secrets")
@Logging = new Mongo.Collection("logging")
@Matches = new Mongo.Collection("matches")
@NLPTasks = new Mongo.Collection("nlp_tasks")
@Documents = new Mongo.Collection("documents")
