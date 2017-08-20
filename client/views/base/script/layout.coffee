################################################
#
# Entry point for all templates
#
################################################

################################################
Template.body_template.onCreated ->
	Meteor.call "log_user",
		(err, res) ->
			if err
				console.log ["error", err]


################################################
Template.render_content.helpers
	ini_context: () ->
		ins = Template.instance()
		return ins.data


################################################
Template.mooqita_layout.onCreated ->
	self = this
	self.is_ready = new ReactiveVar(false)

	self.autorun ->
		Meteor.subscribe "my_profile",
			(err, res) ->
				if err
					sAlert.error "Profile subscription error: " + err
					console.log err
				self.is_ready.set true


################################################
Template.mooqita_layout.helpers
	profile_ready: ->
		return Template.instance().is_ready.get()