Meteor.methods
	find_review: (profile_id) ->
		check profile_id, String
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		profile = Responses.findOne profile_id

		if user._id != profile.owner_id
			throw new Meteor.Error('Not permitted.')

		corpus = collect_keywords user

		filter =
			$text:
				$search: corpus
			type_identifier: "challenge"
			#owner_id:
				#$ne: Meteor.userId()

		meta =
			score:
				$meta: "textScore"

		res = Responses.findOne(filter, meta)#.sort(meta)
		if not res
			throw  new Meteor.Error('We did not found a solution that matches your qualifications. Update your profile to get more review offers.')

		review =
			index: 1
			owner_id: Meteor.userId()
			parent_id: res._id
			view_order: 1
			group_name: ""
			template_id: "review"
			type_identifier: "review"
			visible_to: "owner"

		Responses.insert review

		return true

