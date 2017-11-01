Meteor.methods
  coursetags: (data) ->
    Meteor.call "insertOnboardingForUser", "courseTags", data.tags

  coursetagsSelected: () ->
    # Because this is the first method to be called within the onboarding phase we must
    # create an empty row, e.g. by invoking insertOnboardingForUser with empty params
    courseTags = Onboarding.find({owner_id: this.userId, courseTags: {"$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()
    if (courseTags.length == 0)
      Meteor.call "insertOnboardingForUser", "courseTags", []
      return []
    else
      return courseTags[0].courseTags

  techskills: (data) ->
    doc = Onboarding.find({owner_id: this.userId}, {sort: {created: -1}, limit: 1}).fetch()[0]
    doc.techSkills[data.category] = data.tags
    # TODO: could use the general method, but would create another doc unnecessarily.
    Onboarding.update(doc._id, { $set: techSkills: doc.techSkills } )

  techskillsSelected: (category) ->
    # TODO: error validation & using the same type of find a lot
    techSkills = Onboarding.find({owner_id: this.userId, techSkills: {"$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()
    selectedTechSkillsByCategory = techSkills[0].techSkills[category]
    return if selectedTechSkillsByCategory? then selectedTechSkillsByCategory else []

  storeOrderedTags: (order) ->
    Meteor.call "insertOnboardingForUser", "orderedTags", order

  timeComitted: (time) ->
    Meteor.call "insertOnboardingForUser", "timeComitted", time

  commtags: (data) ->
    Meteor.call "insertOnboardingForUser", "commTags", data.tags

  commtagsSelected: () ->
    commTags = Onboarding.find({owner_id: this.userId, commTags: { "$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()
    if (commTags.length == 0)
      Meteor.call "insertOnboardingForUser", "commTags", []
      return []
    else
      return commTags[0].commTags

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
        courseTags: [],
        orderedTags: {},
        timeComitted: 0,
        commTags: [],
        softSkills: {},
        techSkills: {},
        challenges: []
      }
    Onboarding.update(id, { $set: "#{''+ fieldName + ''}": data})

  last_selected_tags: () ->
    return Onboarding.find({owner_id: this.userId, courseTags: {"$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()[0]

  lastTimeComitted: () ->
    return Onboarding.find({owner_id: this.userId, timeComitted: {"$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()[0].timeComitted