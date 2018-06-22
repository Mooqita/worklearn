// Server Methods For The Questions Collection

Meteor.methods({
    add_question: question => {
        var user = Meteor.user()

        if(!user) {
            throw new Meteor.Error('Not permitted.')
        }

        try {
            for(field in question) {
                if(field === null) {
                    throw new Meteor.Error('Invalid field.')
                }
            }

            inserted_correctly = Questions.insert({
                question: question.question,
                answer_one: question.answer_one,
                answer_two: question.answer_two,
                answer_three: question.answer_three,
                answer_four: question.answer_four,
                correct_answer: question.correct_answer,
                subject: question.subject,
                published: true
            })
        } catch(error) {
            throw new Meteor.Error('Unable to submit.')
        }

        return true
    },

    get_questions: () => {
        var questions = Questions.find({
            published: true
        }).fetch()

        return questions
    },

    get_cobol_questions: () => {
        var questions = Questions.find({
            published: true,
            subject: 'cobol'
        }).fetch()

        return questions
    },

    get_comp_thinking_questions: () => {
        var questions = Questions.find({
            published: true,
            subject: 'comp_thinking'
        }).fetch()

        return questions
    },

    get_python_questions: () => {
        var questions = Questions.find({
            published: true,
            subject: 'python'
        }).fetch()

        return questions
    },

    set_cobol_score: score => {
        var user = Meteor.user()
        var profile = Profiles.findOne({user_id: user._id})

        if(profile.cobol_quiz_score != undefined) {
            return false
        }

        var score_float = parseFloat(score)

        if(score_float >= 70.00) {
            modify_field_unprotected(Profiles, profile._id, 'cobol_course_progress', 100)
            new_balance += score_float
            modify_field_unprotected(Profiles, profile._id, 'my_balance', new_balance)
        } else {
            modify_field_unprotected(Profiles, profile._id, 'cobol_course_progress', 0)
        }

        modify_field_unprotected(Profiles, profile._id, 'cobol_quiz_score', parseFloat(score))
    },

    set_comp_thinking_score: score => {
        var user = Meteor.user()
        var profile = Profiles.findOne({user_id: user._id})

        if(profile.comp_thinking_quiz_score != undefined) {
            false
        }

        var score_float = parseFloat(score)

        if(score_float >= 70.00) {
            modify_field_unprotected(Profiles, profile._id, 'comp_thinking_course_progress', 100)
            new_balance += score_float
            modify_field_unprotected(Profiles, profile._id, 'my_balance', new_balance)
        } else {
            modify_field_unprotected(Profiles, profile._id, 'comp_thinking_course_progress', 0)
        }

        modify_field_unprotected(Profiles, profile._id, 'comp_thinking_quiz_score', parseFloat(score))
    },

    set_python_score: score => {
        var user = Meteor.user()
        var profile = Profiles.findOne({user_id: user._id})
        var new_balance = 0

        if(profile.python_quiz_score != undefined) {
            return false
        }

        if(profile.my_balance != undefined) {
            new_balance = profile.my_balance
        }

        var score_float = parseFloat(score)

        if(score_float >= 70.00) {
            modify_field_unprotected(Profiles, profile._id, 'python_course_progress', 100)
            new_balance += score_float
            modify_field_unprotected(Profiles, profile._id, 'my_balance', new_balance)
        } else {
            modify_field_unprotected(Profiles, profile._id, 'python_course_progress', 0)
        }

        modify_field_unprotected(Profiles, profile._id, 'python_quiz_score', parseFloat(score))
    }
})
