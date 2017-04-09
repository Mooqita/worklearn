#######################################################
#Created by Markus on 23/10/2015.
#Client
#######################################################

#######################################################
Meteor.subscribe "templates"
Meteor.subscribe "responses_with_data", Session.get "response_list"