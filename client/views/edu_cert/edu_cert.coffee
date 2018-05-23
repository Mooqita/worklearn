########################################
#
# list_view
#
########################################

##########################################################
# import
##########################################################

##########################################################
# import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


########################################
# item list
########################################

########################################
Template.edu_certs.onCreated ->
	this.parameter = new ReactiveDict()
	Session.set "selected_cert_template", 0

########################################
Template.edu_certs.helpers
	parameter: () ->
		return Template.instance().parameter

	cert_templates: () ->
		return get_my_documents "edu_cert_template"

########################################
Template.edu_certs.events
	"change #query":(event)->
		event.preventDefault()
		q = event.target.value
		ins = Template.instance()
		ins.parameter.set "query", q

	"click #add_cert_template": () ->
		Meteor.call "add_cert_template",
			(err, res) ->
				if err
					sAlert.error "Add certificate template error: " + err

########################################
# list item
#########################################

########################################
Template.cert_template_preview.helpers
	title: () ->
		if this.title
			return this.title

		return "This challenge does not yet have a title."

	content: () ->
		if this.content
			return this.content

		return "No description available, yet."


########################################
# Certificate template
########################################

########################################
Template.cert_template.onCreated ->
	self = this
	self.send_disabled = new ReactiveVar(false)
	self.recipients = new ReactiveVar("")

	self.autorun ->
		id = FlowRouter.getQueryParam("cert_id")
		if not id
			return
		self.subscribe "my_cert_template_by_id", id

########################################
Template.cert_template.helpers
	cert_template: () ->
		id = FlowRouter.getQueryParam("cert_id")
		return EduCertTemplate.findOne id

	send_disabled: () ->
		disabled = Template.instance().send_disabled.get()
		return disabled

	email: () ->
		return get_user_mail()

	recipients: () ->
		return EduCertRecipients.find()

########################################
Template.cert_template.events
	"click #send_invitations": () ->
		cert_id = FlowRouter.getQueryParam("cert_id")
		inst = Template.instance()
		inst.send_disabled.set true

		recipients = inst.$("#mail_list")[0].value
		console.log recipients

		Meteor.call "add_recipients", cert_id, recipients	,
			(err, res) ->
				inst.send_disabled.set false
				if err
					sAlert.error "Add certificate template error: " + err
				else
					sAlert.success "Messages send"


########################################
# Assertion
########################################

########################################
Template.cert_recipient.onCreated ->
	self = this
	self.send_disabled = new ReactiveVar(false)

	self.autorun ->
		id = FlowRouter.getQueryParam("recipient_id")
		self.subscribe "recipient_by_id", id
		self.subscribe "assertion_by_recipient_id", id


########################################
Template.cert_recipient.helpers
	send_disabled: () ->
		disabled = Template.instance().send_disabled.get()
		return disabled

	recipient: ()->
		id = FlowRouter.getQueryParam("recipient_id")
		return EduCertRecipients.findOne id

	assertion: ()->
		id = FlowRouter.getQueryParam("recipient_id")
		recipient = EduCertRecipients.findOne id

		if not recipient
			return null

		crs = find_cert_assertions recipient

		if crs.count() == 0
			return null

		return crs.fetch()[0]


########################################
Template.cert_recipient.events
	"click #bake_certificate": () ->
		id = FlowRouter.getQueryParam("recipient_id")
		inst = Template.instance()
		inst.send_disabled.set true

		Meteor.call "bake_cert", id,
			(err, res) ->
				inst.send_disabled.set false

				if err
					sAlert.error "Assertion could not be created: " + err
				else
					sAlert.success "Assertion ready!"


########################################
# Issuer
########################################

########################################
Template.cert_issuer.onCreated ->
	self.autorun ->
		id = FlowRouter.getQueryParam("issuer_id")
		self.subscribe "issuer_by_id", id


########################################
Template.cert_recipient.helpers
	issuer: ()->
		return crs.fetch()[0]

