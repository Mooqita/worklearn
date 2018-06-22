Template.comp_thinking_course.onRendered(() => {
	Meteor.call('get_course_progress', (err, res) => {
		Session.set('cobol_course_progress', res.cobol_course_progress)
		Session.set('comp_thinking_course_progress', res.comp_thinking_course_progress)
		Session.set('python_course_progress', res.python_course_progress)
	})

	Meteor.call('get_comp_thinking_modules', (err, res) => {
		Session.set('comp_thinking_modules', res)
	})

	Meteor.call('get_comp_thinking_challenges', (err, res) => {
		Session.set('comp_thinking_challenges', res)
	})

})

Template.comp_thinking_course.helpers({
	'is_module_completed': index => {
		var comp_thinking_course_progress = Session.get('comp_thinking_course_progress')
		var comp_thinking_modules = Session.get('comp_thinking_modules')
		var num_comp_thinking_modules = comp_thinking_modules.length
		var resume_progress = (comp_thinking_course_progress / (100 / num_comp_thinking_modules))
		var return_val = false

		if(index < resume_progress) {
			return_val = true
		}

		return return_val
	},

	'is_module_disabled': index => {
		var comp_thinking_course_progress = Session.get('comp_thinking_course_progress')
		var comp_thinking_modules = Session.get('comp_thinking_modules')
		var num_comp_thinking_modules = comp_thinking_modules.length
		var resume_progress = (comp_thinking_course_progress / (100 / num_comp_thinking_modules))
		var return_val = false

		if(index > resume_progress || (index > 0 && comp_thinking_course_progress == undefined)) {
			return_val = true
		}

		return return_val
	},

	'comp_thinking_modules': () => {
		return Session.get('comp_thinking_modules')
	},

	'comp_thinking_course_progress': () => {
		return Session.get('comp_thinking_course_progress')
	},

    'comp_thinking_module_back': index => {
		return index - 1
    },

    'comp_thinking_module_next': index => {
        return index + 1
    },

	'comp_thinking_module_resume': () => {
		var comp_thinking_course_progress = Session.get('comp_thinking_course_progress')
		var comp_thinking_modules = Session.get('comp_thinking_modules')
		var num_comp_thinking_modules = comp_thinking_modules.length
		var resume_progress = 0

		if(comp_thinking_course_progress != undefined) {
			resume_progress = (comp_thinking_course_progress / (100 / num_comp_thinking_modules))
		}

		return resume_progress
	},

	'comp_thinking_module_resume_title': () => {
		var comp_thinking_course_progress = Session.get('comp_thinking_course_progress')
		var comp_thinking_modules = Session.get('comp_thinking_modules')
		var num_comp_thinking_modules = comp_thinking_modules.length
		var resume_progress = 0

		if(comp_thinking_course_progress != undefined) {
			resume_progress = (comp_thinking_course_progress / (100 / num_comp_thinking_modules))
		}

		if(comp_thinking_modules[resume_progress].title == undefined) {
			return false
		}

		return comp_thinking_modules[resume_progress].title
	},
	
	'completed': () => {
		var course_complete = Session.get('comp_thinking_course_progress')
		if (course_complete >= 100) {
			return true
		} else {
			return false
		}
	},


	'comp_thinking_pretest': () => {
		var course_complete = Session.get('comp_thinking_course_progress')
		if (course_complete >= 100) {
			return false
		} else {
			return true
		}
	},

	// TODO: Hide challenges if current user is challenge owner
	'comp_thinking_challenges': () => {
		//user_id = Meteor.userId() 
		return Session.get('comp_thinking_challenges')
	}
})

Template.comp_thinking_course.events({
	'click .comp_thinking_module_next': event => {
		var comp_thinking_modules = Session.get('comp_thinking_modules')
		var num_comp_thinking_modules = comp_thinking_modules.length

		Meteor.call('update_comp_thinking_course_progress', event.toElement.value, num_comp_thinking_modules)

		Meteor.call('get_course_progress', (err, res) => {
			Session.set('cobol_course_progress', res.cobol_course_progress)
			Session.set('comp_thinking_course_progress', res.comp_thinking_course_progress)
			Session.set('python_course_progress', res.python_course_progress)
		})
	},

	'click #comp_thinking_exam': event => {
		redirect_callback(build_url('comp_thinking_quiz'))
	},

	'click #accept_challenge': event => {
		redirect_callback(build_url('solution?challenge_id='+event.target.value))
	},

})
