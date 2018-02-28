################################################################################
# Onboarding Competency
################################################################################

################################################################################
Template.job_competency.events
	"click .toggle-button": () ->
		instance = Template.instance()
		dict = Session.get "onboarding_job_posting"

		dict["idea"] = if instance.find("#idea_id").checked then 1 else 0
		dict["team"] = if instance.find("#team_id").checked then 1 else 0
		dict["process"] = if instance.find("#process_id").checked then 1 else 0
		dict["strategic"] = if instance.find("#strategic_id").checked then 1 else 0
		dict["contributor"] = if instance.find("#contributor_id").checked then 1 else 0
		dict["social"] = if instance.find("#social_id").checked then 1 else 0

		Session.set "onboarding_job_posting", dict
