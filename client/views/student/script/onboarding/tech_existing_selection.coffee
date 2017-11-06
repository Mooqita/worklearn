Template.onboarding_techexistingselection.helpers
  # This should return all topics, identifying the ones that have been selected?
  topics: () -> return [
    {
      category: "proglang",
      title: "Programming languages",
      tags: ["Python", "C#", "Javascript", "Java", "C++", "CoffeeScript", "R", "Objective C", "Kotlin"]
    },
    {
      category: "databases",
      title: "Database systems",
      tags: ["MongoDB", "MySQL", "Oracle", "SQL"]
    },
    {
      category: "tools",
      title: "Development Tools",
      tags: ["Visual Studio", "GitHub", "GitLab", "Sublime Text", "Atlassian Jira", "WebStorm", "PyCharm", "Vim", "Android Studio", "XCode", "Xamarin Studio"]
    }
  ]