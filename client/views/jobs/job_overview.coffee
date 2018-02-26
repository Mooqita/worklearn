################################################################################
# Job Overview
################################################################################

################################################################################
Template.job_overview.onCreated ->
	self = this

	self.autorun ()->
		org_filter =
			collection_name: "organizations"
		org_admissions = Admissions.find(org_filter).fetch()

		organization_id = ""
		if org_admissions.length > 0
			organization_id = org_admissions[0].resource_id
			self.data.organization_id = organization_id

		self.subscribe "my_organizations", org_admissions

		if self.subscriptionsReady()
			if Organizations.find().count() == 0
				Meteor.call "onboard_organization",
					(err, res) ->
						if res
							sAlert.success("Organization created")
						if err
							sAlert.error(err)
