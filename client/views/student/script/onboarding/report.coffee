Template.onboarding_report.onCreated ->
  Meteor.call "onboardingForUser",
    (err, res) ->
      Session.set("courseContentOrdered", res.orderedTags)
      Session.set("techSkills", res.techSkills)
      Session.set("challenges", res.challenges)
      Session.set("hoursComitted", res.timeComitted)

Template.onboarding_report.helpers
  skills: () -> return Object.values(Session.get("techSkills")).reduce((a,b) -> return a.concat(b))

  likedChallenges: () ->
    return [
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

  courseContent: () ->
    ordered = Session.get("courseContentOrdered")
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

  hours: () -> return Session.get "hoursComitted"