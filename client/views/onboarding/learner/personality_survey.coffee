Template.onboarding_personality_survey.onCreated ->
  this.answers = new ReactiveDict()

Template.onboarding_personality_survey.onRendered () ->
  isComplete = Session.get "personality"
  if isComplete && Object.keys(isComplete).length == 15
    $('#ps-instructions').hide()
    $('.survey').hide()
    $('#finished').show()
  else
    $('.survey').toggle()
    $('#finished').toggle()

Template.onboarding_personality_survey.helpers
  answers: () ->
    return Template.instance().answers

  questions: () ->
    return big_five_short

Template.onboarding_personality_survey.events
  'click #begin': () ->
    $('#ps-instructions').hide()
    $('.survey').toggle()

  'click .select-response': () ->
    answers = Template.instance().answers
    if answers && (Object.keys(answers.keys).length == 15)
      Session.set "personality", answers.keys
      $('.survey').toggle()
      $('#finished').toggle()

  "click #register": () ->
    Modal.show 'onboarding_register'