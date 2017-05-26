#######################################################
@how_much_time = (mls) ->
	sec = 1000
	min = sec*60
	hrs = min*60
	day = hrs*24
	days = mls / day
	if hrs < 6
		return "a few hours"

	if days < 0.75
		return "less than a day"

	if days < 3
		return "a few days"

	if days < 7
		return "less than a week"

	if days < 14
		return "a week"

	if days < 30
		return "less than a month"

	return "more than a month"

################################################################
Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

################################################################
@merge = (dest, objs...) ->
	for obj in objs
		dest[k] = v for k, v of obj
	return dest

################################################################
@non_empty_string = Match.Where (x) ->
  check x, String
  return x.length > 0