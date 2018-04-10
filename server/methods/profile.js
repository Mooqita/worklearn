Meteor.methods({
	add_profile: param => {
		check(param.occupation, String)
		var user = Meteor.user()

		if(!user) {
			throw new Meteor.Error('Not permitted.')
		}

		var profile = Profiles.findOne({user_id: user._id})

		if(profile) {
			throw new Meteor.Error('Profile already created')
		}

		return gen_profile(user)
	},

	get_course_progress: () => {
		var user = Meteor.user()
		var profile = Profiles.findOne({user_id: user._id})

		var course_progress = {
			cobol_course_progress: profile.cobol_course_progress,
			comp_thinking_course_progress: profile.comp_thinking_course_progress,
			python_course_progress: profile.python_course_progress,
		}

		return course_progress
	},

	get_quiz_scores: () => {
		var user = Meteor.user()
		var profile = Profiles.findOne({user_id: user._id})

		var quiz_scores = {
			cobol_quiz_score: profile.cobol_quiz_score,
			comp_thinking_quiz_score: profile.comp_thinking_quiz_score,
			python_quiz_score: profile.python_quiz_score
		}

		return quiz_scores
	}
})
