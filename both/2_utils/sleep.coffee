#######################################################
# Waiting for something
#######################################################

#######################################################
# we will use this once migrating to coffeescript 2.0
#	@sleep = (ms)->
#		return new Promise(resolve => setTimeout(resolve, ms))


#######################################################
@sleep = (ms) ->
  msg = "Sleeping for: " + ms
  log_event msg

  start = new Date().getTime()
  continue while new Date().getTime() - start < ms