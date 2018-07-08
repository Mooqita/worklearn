###############################################################################
# local functions
###############################################################################

###############################################################################
_minify_admissions = () ->
	# Transforming old Admissions to the new format.
	filter =
		consumer_id:
			$exists: true

	crs = Admissions.find(filter)
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


###############################################################################
_clean_admissions = () ->
	crs = Admissions.find()
	dead = []

	crs.forEach (adm) ->
		collection = get_collection(adm.c)
		user_c = Meteor.users.find(adm.u)
		item_c = collection.find(adm.i)

		user_empty = user_c.count() == 0
		item_empty = item_c.count() == 0

		if user_empty or item_empty
			dead.push(adm._id)

	filter =
		_id:
			$in: dead

	count = Admissions.remove(filter)
	return count


###############################################################################
_clean_test_objects = () ->
	collections = [Organizations, Jobs, Challenges, Solutions, Reviews, Feedback, Messages]
	filter =
		test_object: true

	for collection in collections
		count = collection.remove(filter)
		console.log "Deleted " + count + " test objects from: " + collection._name

	Profiles.find(filter).forEach (p) ->
		user_f =
			_id: p.user_id
		count = Meteor.users.remove(user_f)
		console.log "Deleted " + count + " test objects from: Users"

	count = Profiles.remove(filter)
	console.log "Deleted " + count + " test objects from: Profiles"


###############################################################################
# Database Migration
###############################################################################

###############################################################################
Meteor.methods
	all_my_data: () ->
		user = Meteor.user()
		if not user
			throw new Meteor.Error "Not permitted"

		crs = get_my_admissions OWNER, IGNORE, IGNORE
		log_publication crs, user._id, "my_admissions"

		data = {}
		crs.forEach (ad) ->
			collection = get_collection(ad.c)
			if not (ad.c of data)
				data[ad.c] = []

			item = collection.findOne(ad.i)
			item.type = ad.c
			data[ad.c].push(item)

		return data

	all_my_data_json: () ->
		user = Meteor.user()
		if not user
			throw new Meteor.Error "Not permitted"

		crs = get_my_admissions OWNER, IGNORE, IGNORE
		log_publication crs, user._id, "my_admissions"

		data = {}
		crs.forEach (ad) ->
			collection = get_collection(ad.c)
			if not (ad.c of data)
				data[ad.c] = []

			item = collection.findOne(ad.i)
			item.type = ad.c
			data[ad.c].push(item)

		return JSON.stringify(data, null, 2)


	test_database: () ->
		user = Meteor.user()
		if not user
			throw new Meteor.Error "Not permitted"

		msg = "test_database called by: " + get_user_mail()
		log_event msg, event_db, event_info

		_clean_test_objects()
		_clean_admissions()

		try
			run_database_test_bed()
		catch e
			console.log e


	clean_database: () ->
		user = Meteor.user()
		if not user
			throw new Meteor.Error "Not permitted"

		msg = "test_database called by: " + get_user_mail()
		log_event msg, event_db, event_info

		_clean_test_objects()
		_clean_admissions()


	add_documents: () ->
		user = Meteor.user()
		if not user
			throw new Meteor.Error "Not permitted"

		msg = "test_database called by: " + get_user_mail()
		log_event msg, event_db, event_info

		cs = Challenges.find()
		cs.forEach (c) ->
			add_field_to_documents(Challenges, c._id, "content", user)


	migrate_database: () ->
		user = Meteor.user()
		if not user
			throw new Meteor.Error "Not permitted"

		msg = "migrate_database called by: " + get_user_mail()
		log_event msg, event_db, event_info

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

		_minify_admissions()
		_clean_admissions()

