Template.cobol_quiz.helpers({
    quiz: () => {
        return JSON.parse(localStorage.getItem('cobol_quiz'))
    }
})

Template.cobol_quiz.onRendered(() => {
    Meteor.call('get_cobol_questions', (err, res) => {
        localStorage.setItem('cobol_quiz', JSON.stringify(res))
    })

    this.$('#cobol_quiz').submit(event => {
        event.preventDefault()
        var submitted_answers = this.$('#cobol_quiz').serializeArray()
        var quiz = JSON.parse(localStorage.getItem('cobol_quiz'))
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
            $('#cobol_quiz').html('<h1>You can\'t resubmit this quiz.</h1>')
        })

        $('#cobol_quiz').append('<h1><strong>Score</strong>: ' + score + '%</h1>')

        return false
    })
})
