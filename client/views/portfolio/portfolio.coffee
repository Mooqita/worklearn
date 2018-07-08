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
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter


##############################################
# resume list
##############################################

##############################################
Template.portfolio.onCreated () ->
	self = this

	self.autorun () ->
		s_id = FlowRouter.getQueryParam("user_id")
		if !s_id
			s_id = Meteor.userId()
		self.subscribe "user_resumes", s_id

##############################################
Template.portfolio.helpers
	current_resume: () ->
		res = UserResumes.findOne()
		return res

##############################################
# resume solution
##############################################

##############################################
Template.portfolio_solution.onCreated () ->
	this.reviews_visible = new ReactiveVar(false)

##############################################
Template.portfolio_solution.helpers
	shorten: (data) ->
		return data.slice(0, 250)

	average_rating: () ->
		if this.average
			return this.average
		return "-/-"

	reviews_visible: () ->
		return Template.instance().reviews_visible.get()


##############################################
Template.portfolio_solution.events
	"click #show_reviews": () ->
		rv = Template.instance().reviews_visible
		rv.set !rv.get()


##############################################
# portfolio review
##############################################

##############################################
Template.portfolio_review.helpers
	average_rating: () ->
		if this.rating
			return this.rating
		return "-/-"

##############################################
Template.portfolio_review.helpers
	portfolio_url: () ->
		return ""#get_response_url(this.owner_id)


