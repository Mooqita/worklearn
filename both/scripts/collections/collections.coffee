#######################################################
#
# Mooqita
# Created by Markus on 23/10/2016.
#
#######################################################

#######################################################
@Permissions = new Mongo.Collection("permissions")
@Summaries = new Mongo.Collection("summaries")

#######################################################
@Recommendations = new Mongo.Collection("recommendations")
@Challenges = new Mongo.Collection("challenges")
@Solutions = new Mongo.Collection("solutions")
@Feedback = new Mongo.Collection("feedback")
@Profiles = new Mongo.Collection("profiles")
@Messages = new Mongo.Collection("messages")
@Reviews = new Mongo.Collection("reviews")
@Posts = new Mongo.Collection("posts")

#######################################################
@ChallengeSummaries = new Mongo.Collection("challenge_summaries")

#######################################################
@UserResumes = new Mongo.Collection("user_resumes")
@UserSummaries = new Mongo.Collection("user_summaries")

#######################################################
@Admin = new Mongo.Collection("admin")

#######################################################
@Onboarding = new Mongo.Collection("onboarding")
