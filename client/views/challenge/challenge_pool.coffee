###############################################################################
# GitHub challenges
###############################################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter

Template.challenge_pool.onCreated ->
  this.parameter = new ReactiveDict()

Template.challenge_pool.helpers
  parameter: () ->
    Template.instance().parameter

Template.challenge_pool.events

  "change #github_id": () ->
    event.preventDefault()
    q = event.target.checked
    ins = Template.instance()
    ins.parameter.set "github_selected", q

  "change #mooqita_id": () ->
    event.preventDefault()
    q = event.target.checked
    ins = Template.instance()
    ins.parameter.set "mooqita_selected", q

# challenge request default url composition:
# consider header for text match highlighting: curl -H 'Accept: application/vnd.github.v3.text-match+json' 'URLSEARCHCALLHERE'
# https://api.github.com/search/issues?q={query+language:LANGUANGE+type:issue+is:public+archived:false+state:open+label:"help wanted"-label:sprint}&page=PAGE_NO&per_page=PER_PAGE_NO&sort=updated&order=desc
# see: https://developer.github.com/v3/search/#search-issues
Template.challenge_pool_preview.events

  "click #make_challenge": () ->
    #console.log(this)
    loc_job_id = FlowRouter.getQueryParam("job_id")

    Meteor.call "make_challenge", this.title, this.body, this.html_url, this.origin, loc_job_id,
      (err, res) ->
        if err
          sAlert.error("Add challenge error: " + err)
        if res
          query =
            challenge_id: res
          url = build_url "challenge_design", query
          FlowRouter.go url

#HTTP.call( 'GET', 'https://api.github.com/search/issues?per_page=10&page=1&sort=updated&order=desc&q=web+agile+language:ruby+type:issue+is:public+archived:false+state:open', { "options": "to set" }, function( error, response ) {
#  if ( error ) {
#    console.log( error );
#} else {
#  console.log( response );
#});
