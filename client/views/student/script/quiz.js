Template.student_quiz.helpers({
    quiz: () => {
        return JSON.parse(localStorage.getItem('quiz'))
    }
})

Template.student_quiz.onRendered(() => {
    Meteor.call('get_published_questions', (err, res) => {
        localStorage.setItem('quiz', JSON.stringify(res))
    })

    this.$('#student_quiz').submit(event => {
        event.preventDefault()
        var submitted_answers = this.$('#student_quiz').serializeArray()
        var quiz = JSON.parse(localStorage.getItem('quiz'))
        var count = 0

        $('#student_quiz').html('')

        for(let i = 0; i < submitted_answers.length; i++) {
            if(submitted_answers[i].value   == quiz[count][quiz[count].correct_answer]) {
                $('#student_quiz').append('<div>')
                $('#student_quiz').append('<strong>Question ' + (count + 1) + ' Correct:</strong> <br />')
                $('#student_quiz').append(quiz[count][quiz[count].correct_answer])
                $('#student_quiz').append('</div> <br />')
            } else {
                $('#student_quiz').append('<div>')
                $('#student_quiz').append('<strong>Question ' + (count + 1) + ' Incorrect:</strong> <br />')
                $('#student_quiz').append('<span>You said: ' + submitted_answers[i].value + '<span> <br />')
                $('#student_quiz').append('<span>The correct answer was: ' + quiz[count][quiz[count].correct_answer] + '<span> <br />')
                $('#student_quiz').append('</div> <br />')
            }

            count++
        }

        return false
    })
})
