########################################
# load_template
########################################

########################################
Template.dynamic_template_loader.onCreated ->
	self = this
	self.template_name = new ReactiveVar('')
	self.autorun () ->
		challenge_template = self.data.template
		console.log [challenge_template,'dynamic template created']
		self.subscribe "challenge_template", challenge_template

########################################
Template.dynamic_template_loader.helpers
	template_exists: ->
		tn = this.template
		tmpl = Template[tn]
		self = Template.instance()

		if tmpl
			self.template_name.set(tn);
			return true

		challenge = Challenges.findOne(tn)
		if not challenge
			return false

		tmpl_code = challenge.template
		compile_template tn, tmpl_code
		self.template_name.set(tn);

		return true

	template_name: ->
		self = Template.instance()
		return self.template_name.get()



