// Server Methods For The Modules Collection

Meteor.methods({
    get_cobol_modules: () => {
        var raw_modules = Modules.find().fetch()
        var modules = []

        for(let i = 0; i < raw_modules.length; i++) {
            if(raw_modules[i]['published'] == true && raw_modules[i]['subject'] == 'cobol') {
                modules.push({
                    id: raw_modules[i]['_id'],
                    title: raw_modules[i]['title'],
                    description: raw_modules[i]['description'],
                    content: raw_modules[i]['content'],
                    module_number: raw_modules[i]['module_number'],
                    percent_after_completion: raw_modules[i]['percent_after_completion'],
                    subject: raw_modules[i]['subject']
                })
            }
        }

        return modules
    },

    get_comp_thinking_modules: () => {
        var raw_modules = Modules.find().fetch()
        var modules = []

        for(let i = 0; i < raw_modules.length; i++) {
            if(raw_modules[i]['published'] == true && raw_modules[i]['subject'] == 'comp_thinking') {
                modules.push({
                    id: raw_modules[i]['_id'],
                    title: raw_modules[i]['title'],
                    description: raw_modules[i]['description'],
                    content: raw_modules[i]['content'],
                    module_number: raw_modules[i]['module_number'],
                    percent_after_completion: raw_modules[i]['percent_after_completion'],
                    subject: raw_modules[i]['subject']
                })
            }
        }

        return modules
    },

    get_python_modules: () => {
        var raw_modules = Modules.find().fetch()
        var modules = []

        for(let i = 0; i < raw_modules.length; i++) {
            if(raw_modules[i]['published'] == true && raw_modules[i]['subject'] == 'python') {
                modules.push({
                    id: raw_modules[i]['_id'],
                    title: raw_modules[i]['title'],
                    description: raw_modules[i]['description'],
                    content: raw_modules[i]['content'],
                    module_number: raw_modules[i]['module_number'],
                    percent_after_completion: raw_modules[i]['percent_after_completion'],
                    subject: raw_modules[i]['subject']
                })
            }
        }

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
