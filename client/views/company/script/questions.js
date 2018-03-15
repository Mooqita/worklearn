
import { Template } from 'meteor/templating'
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

Template.organization_question.events({
    'submit .organization_question': event => {
        event.preventDefault()

        var question = {
            question: $('input[name="question_question"]').val(),
            answers: [
                $('input[name="question_answer_one"]').val(),
                $('input[name="question_answer_two"]').val(),
                $('input[name="question_answer_three"]').val(),
                $('input[name="question_answer_four"]').val()
            ],
            correct_answer: $('input[name="question_correct_answer"]').val(),
            subject: $('select[name="question_subject"]').val(),
            published: true,
            visible_to: 'anonymous'
        }

        Meteor.call('add_question', question)
    }
})

Template.organization_questions.helpers({
    questions: () => {
        console.log(Question.find().fetch())
    }
})
