##############################################
#
##############################################

##############################################
@dropped_files = {}

##############################################
get_box_id = () ->
	box_id = Template.instance().box_id.get()
	if not box_id
		sAlert.error('Object does not have a box_id')

	return box_id

##############################################
get_files = () ->
	box_id = get_box_id()
	res = dropped_files[box_id]
	return res

##############################################
add_files = (n) ->
	box_id = get_box_id()
	d = dropped_files[box_id]
	Array::push.apply d, n
	dropped_files[box_id] = d
	Session.set('dropped_files', Math.random())

##############################################
get_form = () ->
	box_id = get_box_id()
	frm = $('#dropbox_'+box_id)
	return frm


##############################################
Template.dropfile.onCreated ->
	files = Session.get('dropped_files')

	if not files
		Session.set('dropped_files', Math.random())

	if this.data.name in dropped_files
		sAlert.log('dropfile name: "' + this.data.name + '" already in use.')
		return

	box_id = Math.floor(Math.random()*10000000)
	this.box_id = new ReactiveVar(box_id)
	dropped_files[box_id] = []

##############################################
Template.dropfile.helpers
	files: ->
		if Session.get('dropped_files') != 0
			return get_files()

	box_id: ->
		return get_box_id()

	upload_style: ()->
		div = document.createElement('div')
		do_drag = (('draggable' in div) || ('ondragstart' in div && 'ondrop' in div))
		can_do = do_drag && 'FormData' in window && 'FileReader' in window

		can_do=true

		if can_do == true
			return('has-advanced-upload')
		else
			return('')


##############################################
Template.dropfile.events
	'dropped .dropbox': (event) ->
		n = event.originalEvent.dataTransfer.files
		add_files n
		if not this.multiple
			get_form().trigger('submit')

	'change #file': (event)->
		n = event.target.files
		add_files n
		if not this.multiple
			get_form().trigger('submit')

	'submit form': (event) ->
		event.preventDefault()
		frm = get_form()

		if frm.hasClass('is-uploading')
			return false

		if !Meteor.userId()
			throw new Meteor.Error("not-authorized")

		files = get_files()
		box_id = get_box_id()

		if !files
			throw new Meteor.Error("No files selected to upload.")

		if files.length == 0
			throw new Meteor.Error("No files selected to upload.")

		frm.addClass('is-uploading').removeClass('is-error')

		filesToRead = files.length
		filesRead = 0
		filesUp = 0

		for file in files
			fileReader = new FileReader()
			type = file.type
			col = this.collection
			item = this.item_id
			field = this.field
			method = this.method

			fileReader.onload = (ev) ->
				filesRead += 1
				raw = ev.srcElement.result
				base = btoa(raw)
				data = "data:"+type+";base64,"+base

				Meteor.call method, col, item, field, data, type,
					(err,rsp)->
						filesUp += 1
						if err
							sAlert.error('File upload failed: ' + err)
							frm.addClass('is-error')
						if filesUp==filesToRead
							frm.removeClass('is-uploading')
							dropped_files[box_id] = []
							sAlert.success('Upload done!')

			fileReader.readAsBinaryString(file)

		event.target.files = null

	'dragover .dropbox, dragenter .dropbox': (event)->
		get_form().addClass('is-dragover')

	'dragleave .dropbox, dragend .dropbox, drop .dropbox': (event)->
		get_form().removeClass('is-dragover')

	'dragexit .dropbox': (event) ->
		sAlert.info('exit')

	'click .restart': (event) ->
		get_form().removeClass('is-uploading').removeClass('is-error')