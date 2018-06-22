Template.python_quiz.helpers({
    quiz: () => {
        return Session.get('python_quiz')
    },

    python_quiz_score: () => {
        var python_quiz_score = Session.get('python_quiz_score')

        if(python_quiz_score == undefined) {
            python_quiz_score = false
        }

        return python_quiz_score
    }
})

Template.python_quiz.onRendered(() => {
    Meteor.call('get_python_questions', (err, res) => {
        Session.set('python_quiz', res)
    })

    Meteor.call('get_quiz_scores', (err, res) => {
        Session.set('python_quiz_score', res.python_quiz_score)
    })

    this.$('#python_quiz').submit(event => {
        event.preventDefault()
        var submitted_answers = this.$('#python_quiz').serializeArray()
        var quiz = Session.get('python_quiz')
        var count = 0
        var correct = 0

        $('#python_quiz').html('')

        for(let i = 0; i < submitted_answers.length; i++) {
            if(submitted_answers[i].value == quiz[count][quiz[count].correct_answer]) {
                $('#python_quiz').append('<div>')
                $('#python_quiz').append('<strong>Question ' + (count + 1) + ' Correct:</strong> <br />')
                $('#python_quiz').append(quiz[count][quiz[count].correct_answer])
                $('#python_quiz').append('</div> <br />')
                correct += 1
            } else {
                $('#python_quiz').append('<div>')
                $('#python_quiz').append('<strong>Question ' + (count + 1) + ' Incorrect:</strong> <br />')
                $('#python_quiz').append('<span>You said: ' + submitted_answers[i].value + '<span> <br />')
                $('#python_quiz').append('<span>The correct answer was: ' + quiz[count][quiz[count].correct_answer] + '<span> <br />')
                $('#python_quiz').append('</div> <br />')
            }

            count++
        }

        var score = ((correct / submitted_answers.length) * 100).toFixed(2)

        Meteor.call('set_python_score', score, err => {
            if(!score) {
                $('#python_quiz').html('<h1>You can\'t resubmit this quiz.</h1>')
            }
        })

        $('#python_quiz').append('<h1><strong>Score</strong>: ' + score + '%</h1>')

        return false
    })
})
