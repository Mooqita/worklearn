##############################################
#
# Resume view of solution
# Created by Markus on 15/11/2015.
#
##############################################

##########################################################
# import
##########################################################

##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


##############################################
# resume list
##############################################

##############################################
Template.student_resumes.onCreated () ->
	self = this

	self.autorun () ->
		s_id = FlowRouter.getParam("user_id")
		if !s_id
			s_id = Meteor.userId()
		self.subscribe "user_resumes", s_id

##############################################
Template.student_resumes.helpers
	current_resume: () ->
		res = UserResumes.findOne()
		return res

##############################################
# resume solution
##############################################

##############################################
Template.resume_solution.onCreated () ->
	this.reviews_visible = new ReactiveVar(false)

##############################################
Template.resume_solution.helpers
	average_rating: () ->
		if this.average
			return this.average
		return "-/-"

	reviews_visible: () ->
		return Template.instance().reviews_visible.get()


##############################################
Template.resume_solution.events
	"click #show_reviews": () ->
		rv = Template.instance().reviews_visible
		rv.set !rv.get()


##############################################
# resume review
##############################################

##############################################
Template.resume_review.helpers
	average_rating: () ->
		if this.rating
			return this.rating
		return "-/-"

##############################################
Template.resume_review.helpers
	resume_url: () ->
		return ""#get_response_url(this.owner_id)


