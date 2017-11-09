Template.onboarding_challenges.onRendered ->
  # TODO: could probably achieve this via a CSS hack
  this.$('.card-block').first().toggle()

Template.onboarding_challenges.helpers
  challenges: () -> return [
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

  vote: () -> return Session.get "vote"

import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

Template.onboarding_challenges.events
  "click .like-challenge": (event) ->
    Session.set "vote", 1

  "click .dislike-challenge": (event) ->
    Session.set "vote", 0

  "click .like-challenge, click .dislike-challenge": (event) ->
    id = $(event.target).data("id")
    $(".card-block[data-card-content='" + id + "']").toggle()
    $(".card-block[data-card-justify='" + id + "']").toggle()

  "click .add-justify-challenge, click .skip-justify-challenge": (event) ->
    current_id = $(event.target).data("id")
    justification = $(event.target).parent().find("textarea[name='justifyInput']").val()
    Meteor.call "addChallengeJustification", current_id, justification, Session.get("vote")

    $(".card-block[data-card-justify='" + current_id + "']").toggle()
    $(".card-block[data-card-content='" + (Number.parseInt(current_id) + 1) + "']").toggle()

    # TODO [hack]: if all challenges were responded to, then redirect them to the next page?
    challenges = Template.onboarding_challenges.__helpers.get("challenges").call()
    if (challenges.length) == ((challenges.findIndex (x) -> x.id == current_id) + 1)
      FlowRouter.go("/onboarding/report")