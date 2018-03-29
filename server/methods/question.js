// Server Methods For The Questions Collection

Meteor.methods({
    get_questions: () => {
        return Questions.find().fetch()
    }
})
