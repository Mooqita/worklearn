########################################
Template.more.onCreated ->
	this.expanded = new ReactiveVar(false)

########################################
Template.more.helpers
	has_more: () ->
		if not this.content
			return false
		return this.content.length>250

	content: () ->
		if Template.instance().expanded.get()
			return this.content

		if not this.content
			return "Empty."

		return this.content.substring(0, 250)

	expanded: () ->
		return Template.instance().expanded.get()


########################################
Template.more.events
	"click #expand": (event) ->
		ins = Template.instance()
		s = not ins.expanded.get()
		ins.expanded.set s
