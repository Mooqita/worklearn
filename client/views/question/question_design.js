Template.designed_question.events({
    'submit .designed_question': event => {
        event.preventDefault()
        var correct_answer = ''

        if($('input[name="question_correct_answer"]').val() == '1') {
            correct_answer = 'answer_one'
        } else if($('input[name="question_correct_answer"]').val() == '2') {
            correct_answer = 'answer_two'
        } else if($('input[name="question_correct_answer"]').val() == '3') {
            correct_answer = 'answer_three'
        } else if($('input[name="question_correct_answer"]').val() == '4') {
            correct_answer = 'answer_four'
        } else {
            throw new Meteor.Error('Invalid Submission.')
        }

        Meteor.call('add_question', {
            question: $('input[name="question_question"]').val(),
            answer_one: $('input[name="question_answer_one"]').val(),
            answer_two: $('input[name="question_answer_two"]').val(),
            answer_three: $('input[name="question_answer_three"]').val(),
            answer_four: $('input[name="question_answer_four"]').val(),
            correct_answer: correct_answer,
            subject: $('select[name="question_subject"]').val()
        })

        location.href = '/app/designed_questions'
    }
})

Template.designed_questions.onRendered(() => {
    Meteor.call('get_questions', (err, res) => {
        localStorage.setItem('questions', JSON.stringify(res))
    })
})

Template.designed_questions.helpers({
    questions: () => {
        return JSON.parse(localStorage.getItem('questions'))
    }
})
