Template.onboarding_report.onCreated ->
  this.subscribe "onboardingForUserPUB"

Template.onboarding_report.helpers
  skills: () ->
    return Object.values(Onboarding.find().fetch()[0].techSkills).reduce((a,b) -> return a.concat(b)) || []

  likedChallenges: () ->
    knownChallenges = [
      {
        id: 1,
        title: "Competitive Tweeting",
        text: "Your client would like to view all tweets by their competitors"
      },
      {
        id: 2,
        title: "Bad web design? Sour grapes.",
        text: "Your client would like to know the weather conditions \n" +
          "for crop growth of Freisa grapes in real-time on their tractor. \n" +
          "Implement a website that they could use on their phone \n" +
          "whilst harvesting their crop."
      }
    ]

    userChallenges = Onboarding.find().fetch()[0].challenges
    _likedChallengeKeys = []

    Object.keys(userChallenges).forEach((k) =>
      if userChallenges[k].liked
        _likedChallengeKeys.push(parseInt(k))
    )

    return knownChallenges.filter((c) -> _likedChallengeKeys.includes(c.id))

  courseContent: () ->
    ordered = Onboarding.find().fetch()[0].orderedTags
    return [
      {
        id: 1,
        rank: 1,
        title: ordered['0']
      },
      {
        id: 2,
        rank: 2,
        title: ordered['1']
      },
      {
        id: 3,
        rank: 3,
        title: ordered['2']
      }
    ]

  hours: () -> return Onboarding.find().fetch()[0].timeComitted || 2