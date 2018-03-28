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
    },

	send_message_to_question_learners: (question_id, subject, message) => {
		var user = Meteor.user()

		if(!user) {
			throw new Meteor.Error('Not permitted.')
        }

		if(!Roles.userIsInRole(user._id, 'admin')) {
            throw new Meteor.Error('Not permitted.')
        }

	    // We need to know who is registered for a course.
		var filter = { question_id: question_id }
		var solutions = Solutions.find(filter)

		solutions.forEach(() => {
            var user = Meteor.users.findOne(solution.owner_id)
			var name = get_profile_name_by_user_id(user._id, true, false)
			var subject = subject.replace('<<name>>', name)
			var message = message.replace('<<name>>', name)

			send_mail(user, subject, message)
        })

		return solutions.count()
    }
})
