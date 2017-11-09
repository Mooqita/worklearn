import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

Template.registerHelper('equals', (lhs, rhs) ->
  return lhs == rhs
)

Template.onboarding_header.stages = () ->
  return [
    {
      num: 1,
      desc: "Your Interests",
      urls: ["/onboarding/course/", "/onboarding/sort"]
    },
    {
      num: 2,
      desc: "Your Work Style",
      urls: ["/onboarding/time", "/onboarding/timezone", "/onboarding/softskillselection"]
    },
    {
      num: 3,
      desc: "Your Mooqita",
      urls: ["/onboarding/techexistingselection", "/onboarding/techskillselection", "/onboarding/challenges", "/onboarding/report"]
    }
  ]

Template.onboarding_header.helpers
  stages: () -> return Template.onboarding_header.stages()
  equals: (lhs, rhs) -> return lhs == rhs
  lessThan: (lhs, rhs) -> return lhs > rhs
  firstUrl: () -> 
    if this.urls.length > 0
      return this.urls[0]
    else 
      return ""
  currentStage: () ->
    window.scrollTo(0, 0)
    FlowRouter.watchPathChange()
    for stage in Template.onboarding_header.stages()
      if stage.urls.indexOf(FlowRouter.current().path) > -1
        return stage.num    
    if FlowRouter.current().path == "/onboarding/goodbye"
      return Template.onboarding_header.stages().length + 1
    return 0