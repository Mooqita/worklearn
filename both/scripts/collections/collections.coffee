#######################################################
#Created by Markus on 23/10/2015.
#######################################################

#######################################################
# Moocita
#######################################################

#######################################################
@Permissions = new Mongo.Collection("permissions")
@Summaries = new Mongo.Collection("summaries")

#######################################################
@Challenges = new Mongo.Collection("challenges")
@Solutions = new Mongo.Collection("solutions")
@Feedback = new Mongo.Collection("feedback")
@Profiles = new Mongo.Collection("profiles")
@Messages = new Mongo.Collection("messages")
@Reviews = new Mongo.Collection("reviews")
@Slides = new Mongo.Collection("slides")
@Posts = new Mongo.Collection("posts")

#######################################################
@ChallengeSummary = new Mongo.Collection("challenge_summary")
@TutorSolutions = new Mongo.Collection("tutor_solutions")

#######################################################
@UserCredentials = new Mongo.Collection("user_credentials")
@UserSummaries = new Mongo.Collection("user_summaries")

#######################################################
@Admin = new Mongo.Collection("admin")

