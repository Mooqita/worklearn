import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

Template.learners.helpers({
	all_users: () => {
		return Session.get('profile')
	}
})

Template.learners.onRendered(() => {

    Meteor.call('get_all', (err, res) => {
		Session.set('profile', res)
    })
    
})

Template.learners.events({
    'click .make_payment': event => {
        Modal.show ('learner_select', data)
    }
})