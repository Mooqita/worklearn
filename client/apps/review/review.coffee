Template.student_view.helpers
	solutions: () ->
		filter =
			parent_id: this._id
			template_id: "solution"

		return Responses.find(filter)

	reviews: () ->
		filter =
			parent_id: this._id
			template_id: "review"

		return Responses.find(filter)


Template.student_view.events
	"click #add_solution": () ->
		filter =
			parent_id: this._id
			template_id: "solution"

		index = Responses.find(filter).count()
		Meteor.call "add_response", "solution", index, this._id

	"click #connect": () ->
		Meteor.call "add_connection", this._id, "blub",
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success("Connection updated: " + field)


	"click #add_review": () ->
		filter =
			parent_id: this._id
			template_id: "review"

		index = Responses.find(filter).count()
		Meteor.call "add_response", "review", index, this._id,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success("Connection updated: " + field)



Template.hire_view.helpers
	solutions: () ->
		filter =
			parent_id: this._id
			template_id: "solution"

		return Responses.find(filter)

	reviews: () ->
		filter =
			parent_id: this._id
			template_id: "review"

		return Responses.find(filter)


Template.hire_view.events
	"click #add_solution": () ->
		filter =
			parent_id: this._id
			template_id: "solution"

		index = Responses.find(filter).count()
		Meteor.call "add_response", "solution", index, this._id

	"click #connect": () ->
		Meteor.call "add_connection", this._id, "blub",
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success("Connection updated: " + field)


	"click #add_review": () ->
		filter =
			parent_id: this._id
			template_id: "review"

		index = Responses.find(filter).count()
		Meteor.call "add_response", "review", index, this._id,
			(err, res) ->
				if err
					sAlert.error(err)
				if res
					sAlert.success("Connection updated: " + field)

