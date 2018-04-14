// Server Methods For The Challenge Collection

Meteor.methods({
    add_challenge: () => {
		const user = Meteor.user()

		if(!user) {
			throw new Meteor.Error('Not permitted.')
        }

		return gen_challenge(user)
    },

	finish_challenge: (challenge_id) => {
		var user = Meteor.user()
		var challenge = find_document(Challenges, challenge_id, true)

		return finish_challenge(challenge, user)
    },

	send_message_to_challenge_learners: (challenge_id, subject, message) => {
		var user = Meteor.user()

		if(!user) {
			throw new Meteor.Error('Not permitted.')
        }

		if(!Roles.userIsInRole(user._id, 'admin')) {
            throw new Meteor.Error('Not permitted.')
        }

	    // We need to know who is registered for a course.
		var filter = { challenge_id: challenge_id }
		var solutions = Solutions.find(filter)

		solutions.forEach(() => {
            var user = Meteor.users.findOne(solution.owner_id)
			var name = get_profile_name_by_user_id(user._id, true, false)
			var subject = subject.replace('<<name>>', name)
			var message = message.replace('<<name>>', name)

			send_mail(user, subject, message)
        })

		return solutions.count()
    },

    get_cobol_challenges: () => {
        /**
         * Assistance From StackOverflow User Mr.Cocococo
         * https://stackoverflow.com/questions/24049164/javascript-get-timestamp-of-1-month-ago#24049314
         */
        var last_month = new Date()
        last_month.setMonth(last_month.getMonth() - 1)

        /**
         * Assistance From StackOverflow User Akshat
         * https://stackoverflow.com/questions/24481718/search-date-range-in-meteor
         */
        var challenges = Challenges.find({
            modified: {$gte: last_month},
            course: 'cobol',
            published: true
        }).fetch()

        return challenges
    },

    get_comp_thinking_challenges: () => {
        /**
         * Assistance From StackOverflow User Akshat
         * https://stackoverflow.com/questions/24481718/search-date-range-in-meteor
         */
        var challenges = Challenges.find({
            modified: {$gte: last_month},
            course: 'comp_thinking',
            published: true
        }).fetch()

        return challenges
    },

    get_python_challenges: () => {
        /**
         * Assistance From StackOverflow User Akshat
         * https://stackoverflow.com/questions/24481718/search-date-range-in-meteor
         */
        var challenges = Challenges.find({
            modified: {$gte: last_month},
            course: 'python',
            published: true
        }).fetch()

        return challenges

        return challenges
    }
})
