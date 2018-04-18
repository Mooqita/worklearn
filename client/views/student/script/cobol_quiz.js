Template.cobol_quiz.helpers({
    quiz: () => {
        return Session.get('cobol_quiz')
    },

    cobol_quiz_score: () => {
        var cobol_quiz_score = Session.get('cobol_quiz_score')

        if(cobol_quiz_score == undefined) {
            cobol_quiz_score = false
        }

        return cobol_quiz_score
    }
})

Template.cobol_quiz.onRendered(() => {
    Meteor.call('get_cobol_questions', (err, res) => {
        Session.set('cobol_quiz', res)
    })

    Meteor.call('get_quiz_scores', (err, res) => {
        Session.set('cobol_quiz_score', res.cobol_quiz_score)
    })

    this.$('#cobol_quiz').submit(event => {
        event.preventDefault()
        var submitted_answers = this.$('#cobol_quiz').serializeArray()
        var quiz = Session.get('cobol_quiz')
        var count = 0
        var correct = 0

        $('#cobol_quiz').html('')

        for(let i = 0; i < submitted_answers.length; i++) {
            if(submitted_answers[i].value == quiz[count][quiz[count].correct_answer]) {
                $('#cobol_quiz').append('<div>')
                $('#cobol_quiz').append('<strong>Question ' + (count + 1) + ' Correct:</strong> <br />')
                $('#cobol_quiz').append(quiz[count][quiz[count].correct_answer])
                $('#cobol_quiz').append('</div> <br /> <br />')
                correct += 1
            } else {
                $('#cobol_quiz').append('<div>')
                $('#cobol_quiz').append('<strong>Question ' + (count + 1) + ' Incorrect:</strong> <br />')
                $('#cobol_quiz').append('<span>You said: ' + submitted_answers[i].value + '<span> <br />')
                $('#cobol_quiz').append('<span>The correct answer was: ' + quiz[count][quiz[count].correct_answer] + '<span> <br />')
                $('#cobol_quiz').append('</div> <br /> <br />')
            }

            count += 1
        }

        var score = ((correct / submitted_answers.length) * 100).toFixed(2)

        Meteor.call('set_cobol_score', score, err => {
            if(!score) {
                $('#cobol_quiz').html('<h1>You can\'t resubmit this quiz.</h1>')    
            }
        })

        $('#cobol_quiz').append('<h1><strong>Score</strong>: ' + score + '%</h1>')

        return false
    })
})
