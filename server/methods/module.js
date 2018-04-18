// Server Methods For The Modules Collection

Meteor.methods({
    get_cobol_modules: () => {
        var modules = Modules.find({
            published: true,
            subject: 'cobol'
        }).fetch()

        return modules
    },

    get_comp_thinking_modules: () => {
        var modules = Modules.find({
            published: true,
            subject: 'comp_thinking'
        }).fetch()

        return modules
    },

    get_python_modules: () => {
        var modules = Modules.find({
            published: true,
            subject: 'python'
        }).fetch()

        return modules
    },

    update_cobol_course_progress: (index, num_cobol_modules) => {
        var user = Meteor.user()
        var profile = Profiles.findOne({user_id: user._id})
        var new_value = (100 / num_cobol_modules) * (parseInt(index) + 1)

        if(profile.cobol_course_progress == undefined && new_value <= 100) {
            modify_field_unprotected(Profiles, profile._id, 'cobol_course_progress', new_value)
        } else {
            if
            (
                profile.cobol_course_progress < new_value &&
                new_value == (profile.cobol_course_progress + (100 / num_cobol_modules)) &&
                new_value <= 100
            )
            {
                modify_field_unprotected(Profiles, profile._id, 'cobol_course_progress', new_value)
            } else {
                return false
            }
        }
    },

    update_comp_thinking_course_progress: (index, num_comp_thinking_modules) => {
        var user = Meteor.user()
        var profile = Profiles.findOne({user_id: user._id})
        var new_value = (100 / num_comp_thinking_modules) * (parseInt(index) + 1)

        if(profile.comp_thinking_course_progress == undefined && new_value <= 100) {
            modify_field_unprotected(Profiles, profile._id, 'comp_thinking_course_progress', new_value)
        } else {
            if
            (
                profile.comp_thinking_course_progress < new_value &&
                new_value == (profile.comp_thinking_course_progress + (100 / num_comp_thinking_modules)) &&
                new_value <= 100
            )
            {
                modify_field_unprotected(Profiles, profile._id, 'comp_thinking_course_progress', new_value)
            } else {
                return false
            }
        }
    },

    update_python_course_progress: (index, num_python_modules) => {
        var user = Meteor.user()
        var profile = Profiles.findOne({user_id: user._id})
        var new_value = (100 / num_python_modules) * (parseInt(index) + 1)

        if(profile.python_course_progress == undefined && new_value <= 100) {
            modify_field_unprotected(Profiles, profile._id, 'python_course_progress', new_value)
        } else {
            if
            (
                profile.python_course_progress < new_value &&
                new_value == (profile.python_course_progress + (100 / num_python_modules)) &&
                new_value <= 100
            )
            {
                modify_field_unprotected(Profiles, profile._id, 'python_course_progress', new_value)
            } else {
                return false
            }
        }
    }
})
