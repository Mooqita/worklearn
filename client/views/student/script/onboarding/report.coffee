Template.onboarding_report.onCreated ->
  this.subscribe "onboardingForUserPUB"


Template.onboarding_report.events
  "click .continue": (event) ->
    chall = $("textarea[name='challengeIdea']").val()
    console.log (chall)
    Meteor.call "addChallenge", chall

Template.onboarding_report.helpers
  skills: () ->
    if Onboarding.find().fetch()[0] == undefined then return []
    return Object.values(Onboarding.find().fetch()[0].techSkills).reduce((a,b) -> return a.concat(b)) || []

  likedChallenges: () ->
    knownChallenges = [
      {
        id: 1,
        title: "Competitive Tweeting",
        image: "http://www.evolvingseo.com/wp-content/uploads/2014/08/twitter-analytics.jpg",
        text: "Your client would like to view all of their competitor's tweets and
       get an idea of how each one was emotionally received by their customers.
       Create a website which runs and illustrates a sentiment analysis on responses made
        to each tweet made by a given Twitter account in the last 30 days."
      },
      {
        id: 2,
        title: "Real-time bitcoin analytics",
        image: "https://tctechcrunch2011.files.wordpress.com/2014/02/bitcoin-perfecthue.jpg",
        text: "Scorechain (a blockchain analytics platform) has asked you to determine when an abnormal bitcoin transaction occurs on a per-country basis. They have provided historical transaction data and access to their datastream of all incoming transactions."
      },
      {
        id: 3,
        title: "UK citizens perceptions on #brexit",
        image: "http://cdn.images.express.co.uk/img/dynamic/entities/590x350/23.jpg",
        text: "Using the provided Twitter dataset of 4,000,00 users (100,000,00 tweets) on the week before and after Brexit to explore and visualise how perceptions (positive and negative) changed within the country using sentiment analysis."
      },
      {
        id: 4,
        title: "Parking your bike in the city",
        image: "http://static4.businessinsider.com/image/59f2ebf4cfad3935cf4bfa46-1190-625/a-us-company-is-selling-a-hybrid-between-a-bike-and-a-rowing-machine-that-works-out-your-abs-and-back.jpg",
        text: "A local bike selling shop wants to know where in the city is the safest place for customers to park their bicycles in real-time to stand-out from competitors. Using a Twitter data-stream and national statistics, visualise the safest locations.\n"
      },
      {
        id: 5,
        title: "Reddit: when does a thread reference pineapple on pizza?",
        image: "http://i0.kym-cdn.com/entries/icons/mobile/000/022/141/tumblr_n39t8j2UtP1rfwfq9o1_500.jpg",
        text: "Reddit in collaboration with Dominos has asked for your consultancy to calculate the probability that pineapple on pizza occurs across the entire Reddit dataset for targeted advertising (i.e. to advertise discounts to those particular users). Access to this dataset on AWS (running Apache Spark) is provided."
      }
    ]

    if Onboarding.find().fetch()[0] == undefined then return []
    userChallenges = Onboarding.find().fetch()[0].challenges
    _likedChallengeKeys = []

    Object.keys(userChallenges).forEach((k) =>
      if userChallenges[k].liked
        _likedChallengeKeys.push(parseInt(k))
    )

    return knownChallenges.filter((c) -> _likedChallengeKeys.includes(c.id))

  courseContent: () ->
    if Onboarding.find().fetch()[0] == undefined then return []
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

  hours: () -> 
    if Onboarding.find().fetch()[0] == undefined then return []
    return Onboarding.find().fetch()[0].timeComitted || 2