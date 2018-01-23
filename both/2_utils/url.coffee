##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

##########################################################
_routes =
	learner:
		menu: "learner_menu"
		profile: "learner_profile"
		challenge: "learner_challenge"
		challenges: "learner_challenge"
		review: "learner_review"
	educator:
		menu: "educator_menu"
		profile: "educator_profile"
		challenge: "educator_challenge"
		challenges: "educator_challenges"
	organization:
		menu: "organization_menu"
		profile: "organization_profile"
		challenge: "organization_challenge"
		challenges: "organization_challenges"


##########################################################
@valid_url = (str)->
	pattern = new RegExp '^(https?:\/\/)?'+ 					# protocol
		'((([a-z\d]([a-z\d-]*[a-z\d])*)\.)+[a-z]{2,}|'+ # domain name
		'((\d{1,3}\.){3}\d{1,3}))'+ 										# OR ip (v4) address
		'(\:\d+)?(\/[-a-z\d%_.~+]*)*'+ 									# port and path
		'(\?[;&a-z\d%_.~+=-]*)?'+ 											# query string
		'(\#[-a-z\d_]*)?$','i' 													# fragment locator

	if pattern.test str
		return true

	return false


##############################################
@build_url = (template, query, absolute=false, occupation=null) ->
	if not occupation
		profile = get_profile()
		if profile
			occupation = profile.occupation

	if occupation
		oc_routes = _routes[occupation]
		if oc_routes
			tmp = oc_routes[template]
			if tmp
				template = tmp

	app = if absolute then "app" else "/app"
	url = FlowRouter.path app+"/"+template, null, query

	if absolute
		url = Meteor.absoluteUrl(url)

	return url

