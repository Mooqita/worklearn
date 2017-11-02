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
      title: "Bad web design? Sour grapes.",
      image: "http://www.westernfarmpress.com/sites/westernfarmpress.com/files/styles/article_featured_standard/public/uploads/2015/09/grape-spraying.jpg?itok=ewc3N8eg",
      text: "Your client would like to know the weather conditions for crop growth
       of Freisa grapes in real-time on their tractor. Implement a website that they
        could use on their phone whilst harvesting their crop."
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