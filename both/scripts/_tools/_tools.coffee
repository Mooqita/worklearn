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