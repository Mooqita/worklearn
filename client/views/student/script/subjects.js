// Subjects View

Template.learner_education.events({
	'click #learner_cobol': event => {
		var data = {feedback_id: this._id}
		Modal.show('learner_cobol', data)
	},

	'click #learner_comp_thinking': event => {
		var data = {feedback_id: this._id}
		Modal.show('learner_comp_thinking', data)
	},

	'click #learner_python': event => {
		var data = {feedback_id: this._id}
		Modal.show('learner_python', data)
	}
})

Template.learner_education.onRendered(() => {
	Meteor.call('get_course_progress', (err, res) => {
		Session.set('cobol_course_progress', res.cobol_course_progress)
		Session.set('comp_thinking_course_progress', res.comp_thinking_course_progress)
		Session.set('python_course_progress', res.python_course_progress)
	})
})

Template.cobol_course.onRendered(() => {
	Meteor.call('get_course_progress', (err, res) => {
		Session.set('cobol_course_progress', res.cobol_course_progress)
		Session.set('comp_thinking_course_progress', res.comp_thinking_course_progress)
		Session.set('python_course_progress', res.python_course_progress)
	})
})

Template.comp_thinking_course.onRendered(() => {
	Meteor.call('get_course_progress', (err, res) => {
		Session.set('cobol_course_progress', res.cobol_course_progress)
		Session.set('comp_thinking_course_progress', res.comp_thinking_course_progress)
		Session.set('python_course_progress', res.python_course_progress)
	})
})

Template.learner_education.onRendered(() => {
	Meteor.call('get_course_progress', (err, res) => {
		Session.set('cobol_course_progress', res.cobol_course_progress)
		Session.set('comp_thinking_course_progress', res.comp_thinking_course_progress)
		Session.set('python_course_progress', res.python_course_progress)
	})
})

Template.learner_education.helpers({
	'cobol_course_progress': () => {
		return Session.get('cobol_course_progress')
	},

	'comp_thinking_course_progress': () => {
		return Session.get('comp_thinking_course_progress')
	},

	'python_course_progress': () => {
		return Session.get('python_course_progress')
	}
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

	'cobol_course_progress': () => {
		return Session.get('cobol_course_progress')
	},

	'comp_thinking_course_progress': () => {
		return Session.get('comp_thinking_course_progress')
	},

	'python_course_progress': () => {
		return Session.get('python_course_progress')
	}
})

Template.comp_thinking_course.helpers({
	'cobol_course_progress': () => {
		return Session.get('cobol_course_progress')
	},

	'comp_thinking_course_progress': () => {
		return Session.get('comp_thinking_course_progress')
	},

	'python_course_progress': () => {
		return Session.get('python_course_progress')
	}
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

	'python_course_progress': () => {
		return Session.get('python_course_progress')
	}
})

Template.learner_cobol.events({
	'click #cobol_course': event => {
		var data = {feedback_id: this._id}
		Modal.hide('learner_cobol', data)
		redirect_callback(build_url('cobol_course'))
	}
})

Template.learner_comp_thinking.events({
	'click #comp_thinking_course': event => {
		var data = {feedback_id: this._id}
		Modal.hide('learner_comp_thinking', data)
		redirect_callback(build_url('comp_thinking_course'))
	}
})

Template.learner_python.events({
	'click #python_course': event => {
		var data = {feedback_id: this._id}
		Modal.hide('learner_python', data)
		redirect_callback(build_url('python_course'))
	}
})
