################################################################################
# Match
################################################################################

################################################################################
@match_basic = Match.OneOf String, Number, Boolean

################################################################################
@match_array = [match_basic]

################################################################################
@match_obj = Match.Where (x) ->
		l = Object.keys(x).length
		if l > 1000
			return false

		for key, val of x
			check key, String
			check val, match_basic

		return true

################################################################################
@non_empty_string = Match.Where (x) ->
  check x, String
  return x.length > 0

###############################################################################
@admission_item =
	_id: Match.Optional(String)
	c: String
	u: String
	i: String
	r: String

@admission_list = [admission_item]

