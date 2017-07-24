Template.student_profile.helpers
	email: () ->
		user = Meteor.user()

		if not user.emails
			return "no email registered"

		return user.emails[0].address

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
		if not profile.resume
			return false

		return true

