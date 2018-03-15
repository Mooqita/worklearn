// Server Methods For The Question Collection

Meteor.methods({
    add_question: (question) => {
        var user = Meteor.user()

        if(!user) {
        	throw new Meteor.Error('Not permitted.')
        }

        try {
            question.publish =
        	inserted_correctly = Question.insert(question)
        } catch(error) {
        	throw new Meteor.Error('Unable to submit.')
        }

        return true
    }
})
