########################################
Template.worker_login.onCreated ->
	self = this
	Session.set('templateName','');

	self.autorun () ->
		index = FlowRouter.getParam("index")
		challenge_template = FlowRouter.getParam("challenge_template")
		self.subscribe "response", challenge_template, index

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
					console.log err
					sAlert.error "We could not log you in! " + err
				else
					console.log rsp
					Meteor.loginWithToken rsp.token,
						(err, rsp)->
							if err
								sAlert.error "We could not log you in! " + err
							else
								target.worker_id.value = ""
								sAlert.success("You are logged in.")

########################################
# load_template
########################################

########################################
Template.load_template.onCreated ->
	self = this
	self.autorun () ->
		index = FlowRouter.getParam("index")
		challenge_template = FlowRouter.getParam("challenge_template")
		self.subscribe "challenge_template", challenge_template
		self.subscribe "response", challenge_template, index

########################################
Template.load_template.helpers
	template_exists: ->
		tn = FlowRouter.getParam("challenge_template")
		tmpl = Template[tn]

		if tmpl
			Session.set('templateName', tn);
			return true

		challenge = Challenges.findOne(tn)
		if not challenge
			return false

		tmpl_code = challenge.template
		compile_template challenge._id, tmpl_code
		Session.set('templateName',challenge._id);

		return true

	template_path: ->
		return Session.get('templateName')

	response: ->
		filter =
			challenge_template: FlowRouter.getParam("challenge_template")
			index: FlowRouter.getParam("index")
			owner_id: Meteor.userId()

		response = Responses.findOne(filter)
		console.log response
		return response

########################################
# add_response
########################################

########################################
Template.add_response.onCreated ->
	index = FlowRouter.getParam("index")
	challenge_template = FlowRouter.getParam("challenge_template")
	Meteor.call "add_response", challenge_template, index


