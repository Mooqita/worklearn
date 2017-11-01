Template.onboarding_challenges.onRendered ->
  # TODO: could probably achieve this via a CSS hack
  this.$('.card-block').first().toggle()

Template.onboarding_challenges.helpers
  challenges: () -> return [
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

  vote: () -> return Session.get "vote"

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
    justification = $(event.target).parent().find("input[name='justifyInput']").val()
    Meteor.call "addChallengeJustification", current_id, justification, Session.get("vote")

    $(".card-block[data-card-justify='" + current_id + "']").toggle()
    $(".card-block[data-card-content='" + (Number.parseInt(current_id) + 1) + "']").toggle()

    # TODO [hack]: if all challenges were responded to, then redirect them to the next page?
    challenges = Template.onboarding_challenges.__helpers.get("challenges").call()
    if (challenges.length) == ((challenges.findIndex (x) -> x.id == current_id) + 1)
      alert("Thanks for responding to all challenges. You can now view your responses...")