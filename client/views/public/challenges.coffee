########################################
#
# company challenges view
#
########################################


##########################################################
# import
##########################################################

##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


########################################
# company challenges
########################################

########################################
Template.find_challenges.onCreated ->
	this.parameter = new ReactiveDict()


########################################
Template.find_challenges.helpers
	parameter: () ->
		return Template.instance().parameter

	challenges: () ->
		return Challenges.find()

	title: () ->
		if this.title
			return this.title

		return "This challenge does not yet have a title."

	content: () ->
		if this.content
			return this.content

		return "No description available, yet."

	challenge_link: () ->
		return build_url "challenge", {challenge_id: this._id}

########################################
Template.find_challenges.events
	"change #query":(event)->
		event.preventDefault()
		q = event.target.value
		ins = Template.instance()
		ins.parameter.set "query", q

