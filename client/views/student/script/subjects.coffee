########################################
#
# subjects view
#
########################################
Template.learner_education.events

	"click #learner_cobol":(event)->
		data =
			feedback_id: this._id

		Modal.show 'learner_cobol', data
	

	"click #learner_comp_thinking":(event)->
		data =
			feedback_id: this._id

		Modal.show 'learner_comp_thinking', data
	
	"click #learner_python":(event)->
		data =
			feedback_id: this._id

		Modal.show 'learner_python', data
########################################
Template.learner_cobol.events
########################################

	"click #cobol_close":(event)->
		data =
			feedback_id: this._id

		Modal.hide 'learner_cobol', data

########################################
Template.learner_comp_thinking.events	
########################################

	"click #comp_thinking_close":(event)->
		data =
			feedback_id: this._id

		Modal.hide 'learner_comp_thinking', data

########################################
Template.learner_python.events
########################################

	"click #py_close":(event)->
		data =
			feedback_id: this._id

		Modal.hide 'learner_python', data

##########################################################
