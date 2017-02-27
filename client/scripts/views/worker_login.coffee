########################################
Template.worker_login.onCreated ->
	self = this
	self.autorun () ->
		index = FlowRouter.getParam("index")
		challenge_id = FlowRouter.getParam("challenge_id")
		self.subscribe "challenge_by_id", challenge_id

########################################
# sign_worker
########################################

########################################
Template.sign_worker.events
	"submit #id_form": (event) ->
		event.preventDefault()
		target = event.target
		id = target.worker_id.value

		Meteor.call "sign_in_worker", id,
			(err, rsp)->
				if err
					sAlert.error "We could not log you in! " + err
				else
					Meteor.loginWithToken rsp.token,
						(err, rsp)->
							if err
								sAlert.error "We could not log you in! " + err
							else
								target.worker_id.value = ""
								sAlert.success("You are logged in.")

########################################
# load_response
########################################

########################################
Template.load_response.onCreated ->
	self = this
	self.loaded = new ReactiveVar(false)
	self.autorun () ->
		index = FlowRouter.getParam("index")
		challenge_id = FlowRouter.getParam("challenge_id")
		self.subscribe "response", challenge_id, index,
			onReady: () ->
				self.loaded.set(true)

########################################
Template.load_response.helpers
	template_id: ->
		challenge_id = FlowRouter.getParam("challenge_id")
		challenge = Challenges.findOne challenge_id
		return challenge.template_id

	loaded: ->
		res = Template.instance().loaded.get()
		return res

	response: ->
		challenge_id = FlowRouter.getParam("challenge_id")
		index = FlowRouter.getParam("index")

		filter =
			challenge_id: challenge_id
			owner_id: Meteor.userId()
			index: index

		response = Responses.findOne(filter)
		return response

########################################
# add_response
########################################

########################################
Template.add_response.onCreated ->
	index = FlowRouter.getParam("index")
	challenge_id = FlowRouter.getParam("challenge_id")
	Meteor.call "add_response", challenge_id, index,
		(err, res) ->
			if err
				sAlert.error err
			else
				sAlert. success "Response added"



