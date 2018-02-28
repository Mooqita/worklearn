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

		Modal.show 'learner_comp_thinking', data

	"click #learner_python":(event)->
		data =
			feedback_id: this._id

		Modal.show 'learner_comp_thinking', data
	
##########################################################
