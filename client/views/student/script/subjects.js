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

Template.learner_cobol.events({
	'click #cobol_close': event => {
		var data = {feedback_id: this._id}
		Modal.hide('learner_cobol', data)
	}
})

Template.learner_comp_thinking.events({
	'click #comp_thinking_close': event => {
		var data = {feedback_id: this._id}
		Modal.hide('learner_comp_thinking', data)
	}
})

Template.learner_python.events({
	'click #py_close': event => {
		var data = {feedback_id: this._id}
		Modal.hide('learner_python', data)
	}
})
