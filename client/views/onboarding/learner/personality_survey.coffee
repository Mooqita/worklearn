import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

Template.onboarding_personality_survey.onCreated ->
  this.answers = new ReactiveDict("answers")
  this.item_id = ""
  Meteor.call 'lastInserted',
    (err, res) ->
      this.item_id = res._id
      this.answers = res.personality

Template.onboarding_personality_survey.onRendered () ->
  $('.survey').toggle()

Template.onboarding_personality_survey.helpers
  item_id: () ->
    instance = Template.instance()
    idd = instance.item_id
    return idd

  answers: () ->
    instance = Template.instance()
    answers = instance.answers
    if (Object.keys(answers.keys).length == 15)
      $('.survey').toggle()
      Meteor.call "BIG5S", answers.keys
      # TODO: redirect to final page, i.e. /onboarding/onboarding_finish
    else
      return answers

  questions: () ->
    return big_five_short

  persona_data: () ->
    instance = Template.instance()
    answers = instance.answers
    persona = calculate_persona_40 answers.keys
    instance.persona_data.set persona
    return instance.persona_data.get()

Template.onboarding_personality_survey.events
  'click #begin': () ->
    $('#ps-instructions').hide()
    $('.survey').toggle()