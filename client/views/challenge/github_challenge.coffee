###############################################################################
# GitHub challenges
###############################################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

Template.git_challenge_preview.onCreated ->
  this.parameter = new ReactiveDict()

# challenge request default url composition:
# consider header for text match highlighting: curl -H 'Accept: application/vnd.github.v3.text-match+json' 'URLSEARCHCALLHERE'
# https://api.github.com/search/issues?q={query+language:LANGUANGE+type:issue+is:public+archived:false+state:open+label:"help wanted"-label:sprint}&page=PAGE_NO&per_page=PER_PAGE_NO&sort=updated&order=desc
# see: https://developer.github.com/v3/search/#search-issues
Template.git_challenge_preview.events
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

  "click #make_challenge": () ->
    #console.log(this)
    Meteor.call "make_challenge", this.title, this.body, this.html_url, "github",
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
