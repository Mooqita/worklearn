################################################################
@merge = (dest, objs...) ->
	for obj in objs
		dest[k] = v for k, v of obj
	return dest