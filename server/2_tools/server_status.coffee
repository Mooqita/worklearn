#####################################################
#
# Created by Markus on 7/12/2017.
#
#####################################################


#####################################################
@get_environment = () ->
	if(process.env.ROOT_URL == "http://localhost:3000/")
		return "local"
	else
		return "live"