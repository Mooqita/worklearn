########################################
# company challenges
########################################

########################################
Template.challenges.onCreated ->
	this.parameter = new ReactiveDict()


########################################
Template.challenges.helpers
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


########################################
Template.challenges.events
	"change #query":(event)->
		event.preventDefault()
		q = event.target.value
		ins = Template.instance()
		ins.parameter.set "query", q


########################################
#
# challenge_preview
#
#########################################

########################################
Template.challenge_preview.helpers
	title: () ->
		if this.title
			return this.title

		return "This challenge does not yet have a title."

	content: () ->
		if this.content
			return this.content

		return "No description available, yet."

	challenge_link: () ->
		return build_url "organization_challenge", {challenge_id: this._id}


