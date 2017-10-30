Meteor.methods
  coursetags: (data) ->
    Meteor.call "insertOnboardingForUser", "courseTags", data

  storeOrderedTags: (order) ->
    Meteor.call "insertOnboardingForUser", "orderedTags", order

  timeComitted: (time) ->
    Meteor.call "insertOnboardingForUser", "timeComitted", time

  softskillselection: (collection, item_id, field, value) ->
    # Has this user already created skills?
    doesSoftSkillsExist = Onboarding.find({owner_id: this.userId, softSkills: {"$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()
    skills = {}
    # Then we want to modify those
    if (doesSoftSkillsExist? && doesSoftSkillsExist.length > 0)
      doesSoftSkillsExist[0].softSkills[item_id] = value
      skills = doesSoftSkillsExist[0].softSkills
    else:
      # Otherwise, insert this skill as sole skills
      skills[item_id] = value

    Meteor.call "insertOnboardingForUser", "softSkills", skills

  insertOnboardingForUser: (fieldName, data) ->
    # Does this document exist for the user?
    doc = Onboarding.find({owner_id: this.userId}, {sort: {created: -1}, limit: 1}).fetch()
    if (doc.length > 0)
      id = doc[0]._id
    else
      # If the document does not exist then first create it;
      # TODO: there is probably a simpler way to create a mongoDB schema
      id = store_document_unprotected Onboarding, {
        courseTags: {},
        orderedTags: {},
        timeComitted: 0,
        softSkills: {},
        techSkills: [],
        challenges: []
      }
    Onboarding.update(id, { $set: "#{''+ fieldName + ''}": data})

  last_selected_tags: () ->
    return Onboarding.find({owner_id: this.userId, coursetags: {"$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()[0]