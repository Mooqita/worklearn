#######################################################
@toISOString = (date) ->
	res = date.getUTCFullYear() +
			'-' + pad( date.getUTCMonth() + 1 ) +
			'-' + pad( date.getUTCDate() ) +
			'T' + pad( date.getUTCHours() ) +
			':' + pad( date.getUTCMinutes() ) +
			':' + pad( date.getUTCSeconds() ) +
			'.' + String( (date.getUTCMilliseconds()/1000).toFixed(3) ).slice( 2, 5 ) +
			'Z'

	return res


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