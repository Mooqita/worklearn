_emailPattern = /^([\w.-]+)@([\w.-]+)\.([a-zA-Z.]{2,6})$/i

@check_mail = (mail) ->
	return mail.match _emailPattern
