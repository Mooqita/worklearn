Template.popout_base.onCreated () ->
	this.my_id = new ReactiveVar(5)

Template.popout_base.onRendered () ->
	this.$('#popout_id').popover()

Template.popout_base.helpers
	"my_id" : () ->
		return Template.instance().my_id.get()