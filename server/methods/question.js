// Server Methods For The Question Collection

Meteor.methods({
    add_question: () => {
		const user = Meteor.user()

		if(!user) {
			throw new Meteor.Error('Not permitted.')
        }

		return gen_question(user)
    },

	finish_question: (question_id) => {
		var user = Meteor.user()
		var question = find_document(Questions, question_id, true)

		return finish_question(question, user)
    }
})
