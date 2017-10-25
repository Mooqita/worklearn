Template.onboarding_course.onCreated ->
  this.selectedItems = []


Template.onboarding_course.helpers
  # TODO: populate this data via GET request[s] or educator input?
  title: () -> return "Introduction to Python"
  tags:  () -> return ["API design", "class design", "Flask", "Generators", "Django", "Iterators"]


Template.onboarding_course.events
  "click .course-tag": (event) ->
    if event.target.className.includes("selected")
      event.target.classList.remove("selected")
      Template.instance().selectedItems = Template.instance().selectedItems.filter((e) => e != event.target.innerText)
    else
      event.target.className += " selected"
      Template.instance().selectedItems.push(event.target.innerText)

  "click .continue": (event) ->
    # TODO: save to database for this particular user
    alert(Template.instance().selectedItems)