#######################################################
#Created by Markus on 23/10/2015.
#######################################################

#######################################################
# Moocita
#######################################################

#######################################################
@Permissions = new Mongo.Collection("permissions")
@Templates = new Mongo.Collection("templates")
@Summaries = new Mongo.Collection("summaries")

#######################################################
@Challenges = new Mongo.Collection("challenges")
@Solutions = new Mongo.Collection("solutions")
@Reviews = new Mongo.Collection("reviews")
@Feedback = new Mongo.Collection("feedback")
@Profiles = new Mongo.Collection("profiles")
@Messages = new Mongo.Collection("messages")
@Posts = new Mongo.Collection("posts")
@Slides = new Mongo.Collection("slides")

#######################################################
@UserCredits = new Mongo.Collection("user_credits")
@UserCredentials = new Mongo.Collection("user_credentials")
@TutorSolutions = new Mongo.Collection("tutor_solutions")
@ChallengeSummary = new Mongo.Collection("challenge_summary")

#######################################################
@Admin = new Mongo.Collection("admin")

