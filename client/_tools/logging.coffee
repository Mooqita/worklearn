@log_subscription = (self, subscription, args...) ->
	err = new Error()
	trace = err.stack

	if not self
		self = Meteor

	handler = self.subscribe subscription, args...
	subs = Meteor.default_connection._subscriptions

	inner_stop = subs[handler.subscriptionId].stopCallback
	inner_ready = subs[handler.subscriptionId].readyCallback

	out_ready = (res) ->
		console.log "started"
		if inner_ready
			inner_ready err

	out_stop = (err) ->
		if inner_stop
			inner_stop err
		console.log "stopped"

	subs[handler.subscriptionId].readyCallback = out_ready
	subs[handler.subscriptionId].stopCallback = out_stop

	Meteor.call "log_action", trace[2], handler