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