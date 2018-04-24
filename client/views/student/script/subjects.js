// Subjects View

Template.learner_education.events({
	'click #learner_cobol': event => {
		var data = {feedback_id: this._id}

		if(Session.get('cobol_course_progress') != undefined && parseFloat(Session.get('cobol_course_progress')) > 0) {
			redirect_callback(build_url('cobol_course'))
		} else {
			Modal.show('learner_cobol', data)
		}
	},

	'click #learner_comp_thinking': event => {
		var data = {feedback_id: this._id}

		if(Session.get('comp_thinking_course_progress') != undefined && parseFloat(Session.get('comp_thinking_course_progress')) > 0) {
			redirect_callback(build_url('comp_thinking_course'))
		} else {
			Modal.show('learner_comp_thinking', data)
		}
	},

	'click #learner_python': event => {
		var data = {feedback_id: this._id}

		if(Session.get('python_course_progress') != undefined && parseFloat(Session.get('python_course_progress')) > 0) {
			redirect_callback(build_url('python_course'))
		} else {
			Modal.show('learner_python', data)
		}
	}
})

Template.learner_education.onRendered(() => {
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
