###############################################################################
# Fast hash not cryptographically secure
###############################################################################

###############################################################################
@fast_hash = (str) ->
	hash = 0;
	if not str
		return "#" + hash

	for i in [0..str.length-1]
		char = str.charCodeAt(i)
		hash = ((hash<<5)-hash)+char
		hash = hash & hash

	return "#" + hash * hash

