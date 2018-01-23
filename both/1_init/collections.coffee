#######################################################
#
# Mooqita
# Created by Markus on 23/10/2016.
#
#######################################################

#######################################################
@Permissions = new Mongo.Collection("permissions")
@Admissions =  new Mongo.Collection("admissions")
@Groups = new Mongo.Collection("groups")
@Jobs = new Mongo.Collection("jobs")

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
@UserSummaries = new Mongo.Collection("user_summaries")
@UserResumes = new Mongo.Collection("user_resumes")

#######################################################
@EduCertTemplate = new Mongo.Collection("edu_cert_templates")
@EduCertAssertions = new Mongo.Collection("edu_cert_assertions")
@EduCertRecipients = new Mongo.Collection("edu_cert_recipients")

#######################################################
@Admin = new Mongo.Collection("admin")

