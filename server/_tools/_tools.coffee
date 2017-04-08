################################################################
@merge = (dest, objs...) ->
	for obj in objs
		dest[k] = v for k, v of obj
	return dest


################################################################
@non_empty_string = Match.Where (x) ->
  check x, String
  return x.length > 0