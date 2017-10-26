Template.onboarding_techskillselection.helpers
  # This should return all topics, identifying the ones that have been selected?
  topics: () -> return [
    {
      category: "proglang",
      title: "Programming languages",
      tags: ["Python", "C#", "Javascript", "Java"]
    },
    {
      category: "databases",
      title: "Database management systems",
      tags: ["MongoDB", "MySQL", "Oracle"]
    }
  ]