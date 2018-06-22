Template.python_course.onRendered(() => {
	Meteor.call('get_course_progress', (err, res) => {
		Session.set('cobol_course_progress', res.cobol_course_progress)
		Session.set('comp_thinking_course_progress', res.comp_thinking_course_progress)
		Session.set('python_course_progress', res.python_course_progress)
	})

	Meteor.call('get_python_modules', (err, res) => {
		Session.set('python_modules', res)
	})

	Meteor.call('get_python_challenges', (err, res) => {
		Session.set('python_challenges', res)
	})
})

Template.python_course.helpers({
	'python_course_disabled_text': () => {
		var return_val = false

		if(Session.get('comp_thinking_course_progress') < 100.00 || Session.get('comp_thinking_course_progress') == undefined) {
			return_val = true
		}

		return return_val
	},

	'python_course_disabled': () => {
		var return_val = ''

		if(Session.get('comp_thinking_course_progress') < 100.00 || Session.get('comp_thinking_course_progress') == undefined) {
			return_val = 'disabled'
		}

		return return_val
	},

	'is_module_completed': index => {
		var python_course_progress = Session.get('python_course_progress')
		var python_modules = Session.get('python_modules')
		var num_python_modules = python_modules.length
		var resume_progress = (python_course_progress / (100 / num_python_modules))
		var return_val = false

		if(index < resume_progress) {
			return_val = true
		}

		return return_val
	},

	'is_module_disabled': index => {
		var python_course_progress = Session.get('python_course_progress')
		var python_modules = Session.get('python_modules')
		var num_python_modules = python_modules.length
		var resume_progress = (python_course_progress / (100 / num_python_modules))
		var return_val = false

		if(index > resume_progress || (index > 0 && python_course_progress == undefined)) {
			return_val = true
		}

		return return_val
	},

	'python_modules': () => {
		return Session.get('python_modules')
	},

	'python_course_progress': () => {
		return Session.get('python_course_progress')
	},

    'python_module_back': index => {
		return index - 1
    },

    'python_module_next': index => {
        return index + 1
    },

	'python_module_resume': () => {
		var python_course_progress = Session.get('python_course_progress')
		var python_modules = Session.get('python_modules')
		var num_python_modules = python_modules.length
		var resume_progress = 0

		if(python_course_progress != undefined) {
			resume_progress = (python_course_progress / (100 / num_python_modules))
		}

		return resume_progress
	},

	'python_module_resume_title': () => {
		var python_course_progress = Session.get('python_course_progress')
		var python_modules = Session.get('python_modules')
		var num_python_modules = python_modules.length
		var resume_progress = 0

		if(python_course_progress != undefined) {
			resume_progress = (python_course_progress / (100 / num_python_modules))
		}

		if(python_modules[resume_progress].title == undefined) {
			return false
		}

		return python_modules[resume_progress].title
	},

	'completed': () => {
		var course_complete = Session.get('python_course_progress')
		if (course_complete >= 100) {
			return true
		} else {
			return false
		}
	},

	'python_pretest': () => {
		var course_complete = Session.get('python_course_progress')
		if (course_complete >= 100) {
			return false
		} else {
			return true
		}
	},

	'python_challenges': () => {
		return Session.get('python_challenges')
	}
})

Template.python_course.events({
	'click .python_module_next': event => {
		var python_modules = Session.get('python_modules')
		var num_python_modules = python_modules.length

		Meteor.call('update_python_course_progress', event.toElement.value, num_python_modules)

		Meteor.call('get_course_progress', (err, res) => {
			Session.set('cobol_course_progress', res.cobol_course_progress)
			Session.set('comp_thinking_course_progress', res.comp_thinking_course_progress)
			Session.set('python_course_progress', res.python_course_progress)
		})
	},

	'click #python_exam': event => {
		redirect_callback(build_url('python_quiz'))
	},

	'click #accept_challenge': event => {
		redirect_callback(build_url('solution?challenge_id='+event.target.value))
	},
})
