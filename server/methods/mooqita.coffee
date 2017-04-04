###############################################
_add_review:(challenge, solution) ->
	review_id = Random.id()

	review =
		_id: review_id
		index: 1
		owner_id: Meteor.userId()
		parent_id: solution._id
		challenge_id: challenge._id
		view_order: 1
		group_name: ""
		visible_to: "owner"
		template_id: "review"
		type_identifier: "review"
		date: Date

	feedback =
		index: 1
		owner_id: solution.owner_id
		parent_id: review_id
		solution_id: solution._id
		challenge_id: challenge._id
		view_order: 1
		group_name: ""
		visible_to: "owner"
		template_id: "feedback"
		type_identifier: "feedback"

	insert_document Responses, review
	insert_document Responses, feedback


###############################################
Meteor.methods
	find_review: (profile_id) ->
		check profile_id, String
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		profile = Responses.findOne profile_id

		if user._id != profile.owner_id
			throw new Meteor.Error('Not permitted.')

		filter =
			type_identifier: "review"
			owner_id: user._id
		mod =
			fields:
				challenge_id: 1

		my_reviews = Responses.find(filter, mod).fetch()

		corpus = collect_keywords user
		my_challenges = (m.challenge_id for m in my_reviews)

		filter =
			type_identifier: "challenge"
			_id:
				$nin: my_challenges
			$text:
				$search: corpus

		meta =
			score:
				$meta: "textScore"

		challenge = Responses.findOne(filter, meta)#.sort(meta)
		if not challenge
			throw  new Meteor.Error('Challenge not found')

		filter =
			parent_id: challenge._id
			type_identifier: "solution"
			visible_to: "anonymous"
			owner_id:
				$ne: Meteor.userId()

		solution = Responses.findOne filter
		if not solution
			throw  new Meteor.Error('solution not found')

		_add_review challenge,solution

		return true


###############################################
	find_review_for_challenge: (profile_id, challenge_id) ->
		check profile_id, String
		check challenge_id, String

		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		profile = Responses.findOne profile_id

		if user._id != profile.owner_id
			throw new Meteor.Error('Not permitted.')

		challenge = Responses.findOne(challenge_id)
		if not challenge
			throw  new Meteor.Error('Challenge not found')

		filter =
			parent_id: challenge._id
			type_identifier: "solution"
			visible_to: "anonymous"
			owner_id:
				$ne: Meteor.userId()

		solution = Responses.findOne filter
		if not solution
			throw  new Meteor.Error('solution not found')

		_add_review challenge,solution

		return true

