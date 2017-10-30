Meteor.methods
  coursetags: (data) ->
    # TODO: using the unprotected method (Oh my) to quickly store details for deployment
    res = store_document_unprotected Onboarding, {coursetags: data}
    return {id: res, coursetags: data}

  storeOrderedTags: (order) ->
    return store_document_unprotected Onboarding, {order: order}

  last_selected_tags: () ->
    return Onboarding.find({owner_id: this.userId, coursetags: {"$exists": true}}, {sort: {created: -1}, limit: 1}).fetch()[0]
