Template.onboarding_techskillselection.helpers
  # This should return all topics, identifying the ones that have been selected?
  topics: () -> return [
    {
      category: "proglang",
      title: "Programming languages",
      tags: ["Python", "Javascript", "Java", "C", "C++", "C#", "PHP", "Ruby/Rails", "SQL", "Scala", "Go", "Swift", "CoffeeScript", "R", "Objective C", "Kotlin"]
    },
    {
      category: "cloudPlatforms",
      title: "Cloud Computing Platforms",
      tags: ["Amazon Web Services", "Microsoft Azure", "Google Compute Engine", "Apache CloudStack"]
    },
    {
      category: "tools",
      title: "Development Tools",
      tags: ["Visual Studio", "Git", "SVN", "Sublime Text", "Atlassian Jira", "Vim", "Nano", "Cloud9", "Eclipse", "IntelliJ", "NetBeans", "PyCharm", "MonoDevelop"]
    }
  ]