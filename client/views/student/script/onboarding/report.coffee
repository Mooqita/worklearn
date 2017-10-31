Template.onboarding_report.helpers
  skills: () -> return [
    "MongoDB",
    "MySQL",
    "Android",
    "JSON"
    ]
  likedChallenges: () -> return [
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
  courseContent: () -> return [
    {
      id: 1,
      rank: 1,
      title: "Class structure"
    },
    {
      id: 2,
      rank: 2,
      title: "Inheritance"
    },
    {
      id: 3,
      rank: 3,
      title: "Networking"
    },
  ]
  hours: () -> return 8.5