###############################################################################
#
# Onboarding Learner
#
###############################################################################

###############################################################################
# local variables and methods
################################################################################

################################################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

################################################################################
_check_session = () ->
  if not Session.get "onboarding_challenges"
    Session.set "onboarding_challenges", []

  if not Session.get "own_challenge"
    Session.set "own_challenge", {}

################################################################################
#
# Onboarding Challenge Select
#
################################################################################

################################################################################
Template.onboarding_learner_challenge_select.onCreated ->
  _check_session()


################################################################################
Template.onboarding_learner_challenge_select.helpers
  selected_challenges: () ->
    return Session.get "onboarding_challenges"

  own_challenge: () ->
    return Session.get "own_challenge"

Template.onboarding_learner_challenge_reveal.helpers
  user_profile: () ->
    profile = undefined
    user_id = Meteor.userId()

    if user_id
      profile = Profiles.findOne {user_id: user_id}

    return profile

################################################################################
Template.onboarding_learner_challenge_reveal.events
  "click #register":()->
    Modal.show 'onboarding_learner_register'

################################################################################
#
# Onboarding register
#
################################################################################

################################################################################
Template.onboarding_learner_register.onCreated ->
  AccountsTemplates.setState("signUp")

################################################################################
Template.onboarding_learner_register.helpers
  has_profile: () ->
    profile = undefined
    user_id = Meteor.userId()

    if user_id
      profile = Profiles.findOne {user_id: user_id}

    return profile