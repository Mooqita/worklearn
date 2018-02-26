###############################################
Meteor.methods
	migrate_database: () ->
		collections = [Challenges, Solutions, Reviews, Feedback, Messages, Profiles]

		for collection in collections
			collection.find().forEach (e) ->
				if e.owner_id
					gen_admission(collection, e, e.owner_id, OWNER)
					console.log "Add admission owner: ", get_collection_name collection, e._id

		Profiles.find().forEach (e) ->
			if e.owner_id
				modify_field_unprotected(Profiles, e._id, "user_id", e.owner_id)
				Profiles.update e._id, {$unset: {owner_id: ""}}
				console.log get_collection_name collection, e._id

		crs = Admissions.find()
		dead = []
		minify = []

		crs.forEach (adm) ->
			if not adm.consumer_id
				return

			minify.push(adm)

		for m in minify
			collection = m.collection_name
			item = m.resource_id
			user = m.consumer_id
			role = m.role

			dead.push m._id

			gen_admission(collection, item, user, role)

		filter =
			_id:
				$in: dead

		count = Admissions.remove(filter)
		return count


	clean_admissions: () ->
		crs = Admissions.find()
		dead = []

		crs.forEach (adm) ->
			u_crs = Meteor.users.find(adm.consumer_id)
			if u_crs.count() > 0
				return

			dead.push(adm._id)

		filter =
			_id:
				$in: dead

		count = Admissions.remove(filter)
		return count

