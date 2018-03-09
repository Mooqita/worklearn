###############################################
Meteor.methods
	add_question: (question) ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		try
			inserted_correctly = Question.insert(question)
		catch error
			throw new Meteor.Error('Unable to submit.')

		if inserted_correctly
			console.log('Inserted correctly. ID is: ' + inserted_correctly)

		return true
