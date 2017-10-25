Template.onboarding_sort.onCreated ->
  this.topThree = []

Template.onboarding_sort.helpers
  # TODO: populate based on data from db
  tags: () -> return ["API design", "Flask", "Generators", "Iterators"]