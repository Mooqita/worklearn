##########################################
# Calculate statistics for a user and a
# given cursor of reviews\feedback
##########################################
@calc_statistics = (entry, cursor, prefix) ->
	math = require 'mathjs'

	length = 0
	ratings = []
	count = cursor.count()
	cursor.forEach (e) ->
		if e.content
			length += e.content.split(" ").length
		if e.rating
			ratings.push e.rating

	avg = math.sum ratings / count

	entry[prefix+"_count"] = count
	entry[prefix+"_average_length"] = length / count
	entry[prefix+"_average_rating"] = avg
	entry[prefix+"_rating_bias"] = avg - 2.5
	entry[prefix+"_rating_sd"] = if ratings.length then math.std(ratings) else 0.0
	entry[prefix] = cursor.fetch()

	return entry
