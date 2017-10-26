Template.onboarding_course.helpers
  # TODO: populate this data via GET request[s] or educator input?
  title: () -> return "Introduction to Python"
  tags:  () -> return ["API design", "class design", "Flask", "Generators", "Django", "Iterators"]


Template.onboarding_course.events
  "click .continue": (event) ->
    # TODO: this can be undefined
    selectedTags = Session.get "coursetags"
    if (selectedTags.length) < 3
      alert("At least three tags must be selected")
    alert(selectedTags)