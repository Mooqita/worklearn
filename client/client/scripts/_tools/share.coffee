Template.share.helpers
	opts: () ->
		opts =
			email: true
			facebook: true
			googlePlus: true
			linkedIn: true
			pinterest: true
			sms: true
			twitter: true
			shareData:
				url: 'https://www.worklearn.org'
				facebookAppId: '1344198818974408'
				subject: 'Moocita'
				body: 'Helping people to earn money while learning.'
				redirectUrl: 'http://localhost:3000/test'

		return opts
