quiz = [
    {
        question: 'Is this a question?'
        answers: [
            'Answer 1',
            'Answer 2',
            'Answer 3',
            'Answer 4'
        ],
        correct_answer: 'Answer 4'
    },
    {
        question: 'Is this another question?'
        answers: [
            'Answer 5',
            'Answer 6',
            'Answer 7',
            'Answer 8'
        ],
        correct_answer: 'Answer 6'
    }
]

Template.student_quiz.helpers
    quiz: () ->
        return quiz

Template.student_quiz.onRendered ->
    this.$('.student_quiz').submit ->
        submitted_answers = $(this).serializeArray()
        count = 0

        $(this).html('')

        for submitted_answer in submitted_answers
            if(submitted_answer.value == quiz[count].correct_answer)
                $(this).append('<div>')
                $(this).append('<strong>Question ' + (count + 1) + ' Correct:</strong> <br />')
                $(this).append(quiz[count].correct_answer)
                $(this).append('</div>')
            else
                $(this).append('<div>')
                $(this).append('<strong>Question ' + (count + 1) + ' Incorrect:</strong> <br />')
                $(this).append('<span>You said: ' + submitted_answer.value + '<span> <br />')
                $(this).append('<span>The correct answer was: ' + quiz[count].correct_answer + '<span> <br />')
                $(this).append('</div>')
            $(this).append('<br />')
            count++

        return false
