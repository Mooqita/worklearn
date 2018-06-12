###############################################################################
# Personal Profile
###############################################################################

###############################################################################
saveAs = require("file-saver").saveAs

###############################################################################
Template.profile.helpers
	email: () ->
		return get_user_mail()

	mail_notifications_options:() ->
		return [{value:"", label:"Notifications ?"}
			{value:"yes", label:"Yes, please"}
			{value:"no", label:"No, thanks"}]


	job_interested_options:() ->
		return [{value:"", label:"Are you looking for a job?"}
			{value:"yes", label:"Yes, sounds interesting"}
			{value:"no", label:"No, maybe later"}]


	job_type_options: () ->
		return [{value:"", label:"Part or Full time?"}
			{value:"full", label:"Full Time"}
			{value:"part", label:"Part Time"}
			{value:"free", label:"Freelance"}]

	job_locale_options: () ->
		return [{value:"", label:"Remote or on Site?"}
			{value:"remote", label:"I want to work from home"}
			{value:"local", label:"I want to work on site"}]

	job_interested: () ->
		profile = get_profile()
		return profile.job_interested=="yes"

	profile_done: () ->
		profile = get_profile()

		if not profile.job_interested
			return false
		if not profile.given_name
			return false
		if not profile.family_name
			return false
		if not profile.avatar
			return false
		#if not profile.resume
		#	return false

		return true

###############################################################################
# All my data
###############################################################################

###############################################################################
Template.all_my_data.onCreated () ->
	self = this
	self.my_data = ReactiveVar()
	self.my_data_json = ReactiveVar()

	Meteor.call "all_my_data",
		(err, res) ->
			if err
				sAlert.error(err)
			self.my_data.set(res)

###############################################################################
Template.all_my_data.helpers
	my_data_json: () ->
		inst = Template.instance()
		data = inst.my_data_json.get()
		return data

	my_data: () ->
		inst = Template.instance()
		data = inst.my_data.get()

		res = []
		for k, d of data
			res.push({type:k, items:d})

		return res

	field: (data) ->
		res = []
		for k,d of data
			res.push({label:k, value:d})

		return res


###############################################################################
Template.all_my_data.events
	"click .export-data": (event, template) ->
		$(event.target).button("loading")

		Meteor.call "all_my_data_json",
			(err, res) ->
				if err
					sAlert.error(err)
					return

				data = new Blob([res], {type: "text/json"})
				saveAs(data, "user_data_mooqita.json")
				$(event.target).button("reset")

