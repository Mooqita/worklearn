class SubscriptionCacher
	constructor: (name, args) ->
		this.name = name
		this.args = args
		this.shouldCancel = false
		this.run()

	subscribe: () ->
		if (!this.handle)
			this.handle = Meteor.subscribe(this.name, this.args)

	stop:() ->
		if (!this.handle)
			return;

		this.handle.stop()
		this.handle = null

	run:() ->
		callback () ->
			if (this.shouldCancel)
				this.stop()

		setInterval callback, 2000
