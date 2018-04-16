import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

Template.learners.helpers({
	all_users: () => {
		return Session.get('profile')
    },

    email: () => {
		return get_user_mail()
    },
    
    quiz_scores: () => {
        return Session.get('quiz_scores')
    },

    my_balance: () => {
        return Session.get('my_balance')
    },
    
    admin: () => {
        if (email == 'jorge@gmail.com') {
            return true
        } else {
            return false
        }
    }
})

Template.learners.onRendered(() => {

    Meteor.call('get_all', (err, res) => {
		Session.set('profile', res)
    }),

    Meteor.call('get_user_mail', (err, res) => {
        Session.set('email', res)
    }),

    Meteor.call('get_admin', (err, res) => {
        Session.set('email', res)
    })
})

Template.learners.events({
    'click #make_payment': event => {
        Modal.show ('learner_select', data)
    }
})