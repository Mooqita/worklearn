Template.student_quiz.helpers
    quiz: () ->
        questions_raw = JSON.parse(localStorage.getItem('questions'))
        quiz = []

        for question in questions_raw
            quiz.push({
                question: question.question,
                answer_one: question.answer_one,
                answer_two: question.answer_two,
                answer_three: question.answer_three,
                answer_four: question.answer_four,
                correct_answer: question.correct_answer
            })

        return quiz

Template.student_quiz.onRendered ->
    Meteor.call 'get_questions', (err, res) ->
        localStorage.setItem('questions', JSON.stringify(res))

    this.$('.student_quiz').submit ->
        submitted_answers = $(this).serializeArray()
        count = 0
        $(this).html('')

        for submitted_answer in submitted_answers
            if(submitted_answer.value == quiz[count][quiz[count].correct_answer])
                $(this).append('<div>')
                $(this).append('<strong>Question ' + (count + 1) + ' Correct:</strong> <br />')
                $(this).append(quiz[count][quiz[count].correct_answer])
                $(this).append('</div> <br />')
            else
                $(this).append('<div>')
                $(this).append('<strong>Question ' + (count + 1) + ' Incorrect:</strong> <br />')
                $(this).append('<span>You said: ' + submitted_answer.value + '<span> <br />')
                $(this).append('<span>The correct answer was: ' + quiz[count][quiz[count].correct_answer] + '<span> <br />')
                $(this).append('</div> <br />')
            count++

        return false
