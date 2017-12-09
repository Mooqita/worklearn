##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

##########################################################
_routes =
	learner:
		menu: "student_menu"
		profile: "student_profile"
		challenge: "student_solution"#"learner_challenge"
		challenges: "student_solutions"#"learner_challenge"
		review: "student_review"
	teacher:
		menu: "teacher_menu"
		profile: "teacher_profile"
		challenge: "teacher_challenge"
		challenges: "teacher_challenges"
	company:
		menu: "company_menu"
		profile: "company_profile"
		challenge: "company_challenge"
		challenges: "company_challenges"


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
@build_url = (template, query, absolute=false, lookup=true) ->
	if lookup
		profile = get_profile()
		if profile
			oc_routes = _routes[profile.occupation]
			if oc_routes
				tmp = oc_routes[template]
				if tmp
					template = tmp

	app = if absolute then "app" else "/app"
	url = FlowRouter.path app+"/"+template, null, query

	if absolute
		url = Meteor.absoluteUrl(url)

	return url

