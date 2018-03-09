Template.organization_question.events({
    'submit .organization_question': (event) ->
        event.preventDefault()

        Meteor.call('add_question', {
            question: $('input[name="question_question"]').val()
            answers: [
                $('input[name="question_answer_one"]').val()
                $('input[name="question_answer_two"]').val()
                $('input[name="question_answer_three"]').val()
                $('input[name="question_answer_four"]').val()
            ]
            correct_answer: $('input[name="question_correct_answer"]').val()
            subject: $('select[name="question_subject"]').val()
        })

        location.href = '/app/organization_quiz'
})
