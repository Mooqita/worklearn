Template.onboarding_techexistingselection.helpers
  # TODO: store these tags in the database, if necessary.
  topics: () -> return [
    {
      category: "proglang",
      title: "Programming languages",
      tags: ["Python", "Javascript", "Java", "C", "C++", "C#", "PHP", "Ruby/Rails", "SQL", "Scala", "Go", "Swift", "CoffeeScript", "R", "Objective C", "Kotlin"]
    },
    {
      category: "tools",
      title: "Development Tools",
      tags: ["Visual Studio", "Git", "SVN", "Sublime Text", "Atlassian Jira", "Vim", "Nano", "Cloud9", "Eclipse", "IntelliJ", "NetBeans", "PyCharm", "MonoDevelop"]
    }
  ]
