Template.cobol_course.onRendered(() => {
	Meteor.call('get_course_progress', (err, res) => {
		Session.set('cobol_course_progress', res.cobol_course_progress)
		Session.set('comp_thinking_course_progress', res.comp_thinking_course_progress)
		Session.set('python_course_progress', res.python_course_progress)
	})

	Meteor.call('get_cobol_modules', (err, res) => {
		Session.set('cobol_modules', res)
	})
})

Template.cobol_course.helpers({
	'cobol_course_disabled_text': () => {
		var return_val = false

		if(Session.get('comp_thinking_course_progress') < 100.00 || Session.get('comp_thinking_course_progress') == undefined) {
			return_val = true
		}

		return return_val
	},

	'cobol_course_disabled': () => {
		var return_val = ''

		if(Session.get('comp_thinking_course_progress') < 100.00 || Session.get('comp_thinking_course_progress') == undefined) {
			return_val = 'disabled'
		}

		return return_val
	},

	'is_module_completed': index => {
		var cobol_course_progress = Session.get('cobol_course_progress')
		var cobol_modules = Session.get('cobol_modules')
		var num_cobol_modules = cobol_modules.length
		var resume_progress = (cobol_course_progress / (100 / num_cobol_modules))
		var return_val = false

		if(index < resume_progress) {
			return_val = true
		}

		return return_val
	},

	'is_module_disabled': index => {
		var cobol_course_progress = Session.get('cobol_course_progress')
		var cobol_modules = Session.get('cobol_modules')
		var num_cobol_modules = cobol_modules.length
		var resume_progress = (cobol_course_progress / (100 / num_cobol_modules))
		var return_val = false

		if(index > resume_progress || (index > 0 && cobol_course_progress == undefined)) {
			return_val = true
		}

		return return_val
	},

	'cobol_modules': () => {
		return Session.get('cobol_modules')
	},

	'cobol_course_progress': () => {
		return Session.get('cobol_course_progress')
	},

    'cobol_module_back': index => {
		return index - 1
    },

    'cobol_module_next': index => {
        return index + 1
    },

	'cobol_module_resume': () => {
		var cobol_course_progress = Session.get('cobol_course_progress')
		var cobol_modules = Session.get('cobol_modules')
		var num_cobol_modules = cobol_modules.length
		var resume_progress = 0

		if(cobol_course_progress != undefined) {
			resume_progress = (cobol_course_progress / (100 / num_cobol_modules))
		}

		return resume_progress
	},

	'cobol_module_resume_title': () => {
		var cobol_course_progress = Session.get('cobol_course_progress')
		var cobol_modules = Session.get('cobol_modules')
		var num_cobol_modules = cobol_modules.length
		var resume_progress = 0

		if(cobol_course_progress != undefined) {
			resume_progress = (cobol_course_progress / (100 / num_cobol_modules))
		}

		return cobol_modules[resume_progress].title
	}
})

Template.cobol_course.events({
	'click .cobol_module_next': event => {
		var cobol_modules = Session.get('cobol_modules')
		var num_cobol_modules = cobol_modules.length

		Meteor.call('update_cobol_course_progress', event.toElement.value, num_cobol_modules)
		
		Meteor.call('get_course_progress', (err, res) => {
			Session.set('cobol_course_progress', res.cobol_course_progress)
			Session.set('comp_thinking_course_progress', res.comp_thinking_course_progress)
			Session.set('python_course_progress', res.python_course_progress)
		})
	}
})
