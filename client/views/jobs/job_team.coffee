#########################################################
# Team Member
#########################################################

##########################################################
# local variables and methods
##########################################################

##########################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter

#########################################################
_refresh = (mails)->
	$('#user_select').empty()

	for mail in mails
		console.log mail
		html = '<option data-tokens="' + mail + '">' + mail + '</option>'
		$('#user_select').append html

	$('.user_select_class').selectpicker 'refresh'


#########################################################
Template.group_page.onCreated ()  ->
	self = this
	self.selected = new ReactiveVar([])
	self.candidates = new ReactiveVar([])
	o_id = FlowRouter.getQueryParam("organization_id")

	self.autorun () ->
		self.subscribe "team_members_by_organization_id", o_id
		self.subscribe "invitations_by_organization_id", o_id

	self.find_user = (event) ->
		event = event || window.event
		switch event.keyCode
			when 38 then return
			when 40 then return
			when 37 then return
			when 39 then return

		value = event.target.value
		Meteor.call "find_user", value,
			(err, res) ->
				if res
					mails = (a.emails[0].address for a,index in res)
					mails.push value
					_refresh(mails)

	self.update_selected = (event) ->
		mails = $('.user_select_class').val()

		for val in mails
			if not check_mail val
				return

			selected = new Set(self.selected.get())
			selected.add val

			new_selected = Array.from(selected)
			self.selected.set new_selected


#########################################################
Template.group_page.onRendered () ->
	$(".selectpicker").selectpicker()


#########################################################
Template.group_page.helpers
	has_profile: () ->
		profile = undefined
		user_id = Meteor.userId()

		if user_id
			profile = get_profile(user_id)

		return profile

	selected_users: () ->
		inst = Template.instance()
		return inst.selected.get()

	invitations: () ->
		return Invitations.find()

	invitation_url: (invitation) ->
		param =
			organization_id: invitation.organization_id
			invitation_id: invitation._id

		return build_url "invitation", param

	members: () ->
		return TeamMembers.find()

	get_given_name: (profile) ->
		get_profile_name profile

	default_persona: () ->
		return persona_job

	persona_data: (profile) ->
		if not profile.big_five
			return undefined

		persona_5 = calculate_persona profile.big_five
		persona_job = persona_map persona_5, persona_map_person_to_job

		return persona_job


#########################################################
Template.group_page.events
	"show.bs.select .user_select_class": () ->
		inst = Template.instance()

		$(".user_select_class input").off "keyup", inst.find_user
		$(".user_select_class input").on "keyup", inst.find_user

		$(".selectpicker").off "changed.bs.select", inst.update_selected
		$(".selectpicker").on "changed.bs.select", inst.update_selected

	"click .auto-complete-list-item": (event) ->
		inst = Template.instance()
		val = event.target.id

		selected = new Set(inst.selected.get())
		selected.delete val

		new_selected = Array.from(selected)
		inst.selected.set new_selected

	"click #invite": () ->
		inst = Template.instance()
		selected = inst.selected.get()
		org = Organizations.findOne()

		Meteor.call "invite_team_member", org._id, selected,
			(err, res) ->
				if err
					sAlert.error err

				sAlert.success "Invitation send"
				inst.selected.set([])


