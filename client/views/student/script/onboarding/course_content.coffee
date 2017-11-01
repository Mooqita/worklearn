Template.onboarding_course.helpers
  # TODO: populate this data via GET request[s] or educator input?
  title: () -> return "Introduction to Python"
  tags:  () -> return ["API design", "class design", "Flask", "Generators", "Django", "Iterators"]
  errorMessage: () -> return Session.get "errorMessage"

Template.onboarding_course.events
  "click .continue": (event) ->
    # Note: this is set in the onboarding/tags component
    selectedTags = Session.get "coursetagsSelected"
    if selectedTags == undefined || (selectedTags.length) < 3
      Session.set "errorMessage", true
      return false
    Session.set "errorMessage", false