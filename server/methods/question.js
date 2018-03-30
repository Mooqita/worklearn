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
                published: question.published
            })
        } catch(error) {
            throw new Meteor.Error('Unable to submit.')
        }

        if(inserted_correctly) {
            console.log('Inserted correctly. ID is: ' + inserted_correctly)
        }

        return true
    },

    get_questions: () => {
        var raw_questions = Questions.find().fetch()
        var questions = []

        for(let i = 0; i < raw_questions.length; i++) {
            questions.push({
                id: raw_questions[i]['_id'],
                question: raw_questions[i]['question'],
                answer_one: raw_questions[i]['answer_one'],
                answer_two: raw_questions[i]['answer_two'],
                answer_three: raw_questions[i]['answer_three'],
                answer_four: raw_questions[i]['answer_four'],
                correct_answer: raw_questions[i]['correct_answer'],
                subject: raw_questions[i]['subject'],
                published: raw_questions[i]['published'],
            })
        }

        return questions
    },

    get_published_questions: () => {
        var raw_questions = Questions.find().fetch()
        var questions = []

        for(let i = 0; i < raw_questions.length; i++) {
            if(!raw_questions[i]['published'] != true) {
                questions.push({
                    id: raw_questions[i]['_id'],
                    question: raw_questions[i]['question'],
                    answer_one: raw_questions[i]['answer_one'],
                    answer_two: raw_questions[i]['answer_two'],
                    answer_three: raw_questions[i]['answer_three'],
                    answer_four: raw_questions[i]['answer_four'],
                    correct_answer: raw_questions[i]['correct_answer'],
                    subject: raw_questions[i]['subject'],
                    published: raw_questions[i]['published'],
                })
            }
        }

        return questions
    }
})
