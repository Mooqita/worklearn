Template.onboard_learner_registered.helpers
  profile_done: () ->
    profile = get_profile()

    if not profile.job_interested
      return false
    if not profile.given_name
      return false
    if not profile.family_name
      return false
    if not profile.avatar
      return false
    if not profile.resume
      return false

    return true