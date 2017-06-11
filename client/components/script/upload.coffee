##############################################
#
##############################################

##############################################
_files = {}

_get_file_data_from_event = (event) ->
	if event.srcElement
		crm_data = event.srcElement.result
		if crm_data
			return crm_data

	if event.target
		moz_data = event.target.result
		if moz_data
			return moz_data

	msg = "We encountered a problem with your browser uploading a file."
	msg += "Please contact info@mooqita.org."
	sAlert.error msg

	throw new Meteor.Error msg


##############################################
_get_file_size_text = (byte) ->
	kb = Math.round(byte / 1024)
	if kb < 500
		return kb + " Kbyte"

	mb = Math.round(kb / 1024)
	if mb < 1
		return Math.round(kb / 1024, 2)

	return mb + " Mbyte"


##############################################
get_box_id = () ->
	box_id = Template.instance().box_id.get()
	if not box_id
		sAlert.error('Object does not have a box_id')

	return box_id

##############################################
get_files = () ->
	box_id = get_box_id()
	res = _files[box_id]
	return res

##############################################
add_files = (n, box_id = null) ->
	if not box_id
		box_id = get_box_id()
	d = _files[box_id]
	Array::push.apply d, n
	_files[box_id] = d
	Session.set('_files', Math.random())

##############################################
get_form = (box_id = null) ->
	if not box_id
		box_id = get_box_id()
	frm = $('#dropbox_'+box_id)
	return frm

##############################################
# Upload
##############################################

##############################################
Template.upload.onCreated ->
	this.uploaded = new ReactiveVar("")

	files = Session.get('_files')

	if not files
		Session.set('_files', Math.random())

	if this.data.name in _files
		sAlert.log('download name: "' + this.data.name + '" already in use.')
		return

	box_id = Math.floor(Math.random()*10000000)
	this.box_id = new ReactiveVar(box_id)
	_files[box_id] = []

##############################################
Template.upload.helpers
	uploaded: ->
		return Template.instance().uploaded.get()

	files: ->
		if Session.get('_files') != 0
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
Template.upload.events
	'dropped .dropbox': (event) ->
		n = event.originalEvent.dataTransfer.files
		if n.length == 0
			box_id = get_box_id()
			event.originalEvent.dataTransfer.items[0].getAsString (data)->
				add_files ['"'+data+'"'], box_id
				if not this.multiple
					get_form(box_id).trigger('submit')
		else
			add_files n
			if not this.multiple
				get_form().trigger('submit')


	'change #file': (event)->
		n = event.target.files
		add_files n
		if not this.multiple
			get_form().trigger('submit')


	'submit form': (event) ->
		self = Template.instance()
		event.preventDefault()
		frm = get_form()

		if frm.hasClass('is-uploading')
			return false

		if !Meteor.userId()
			sAlert.error "Please login to upload files."
			return

		files = get_files()
		box_id = get_box_id()

		if !files
			sAlert.error "No files selected to upload."
			return

		if files.length == 0
			sAlert.error ("No files selected to upload.")
			return

		frm.addClass('is-uploading').removeClass('is-error')

		filesToRead = files.length
		filesRead = 0
		filesUp = 0

		cumulative_size = 0
		max_size = this.max_size

		if not max
			max = 4*1024*1024

		for file in files
			col = this.collection_name
			item = this.item_id
			field = this.field

			fileReader = new FileReader()
			type = file.type

			if not typeof file == "object"
				sAlert.error 'File upload failed not a valid file.'
				continue

			fileReader.onload = (ev) ->
				filesRead += 1
				raw = _get_file_data_from_event(ev)
				base = btoa(raw)
				data = "data:" + type + ";base64," + base

				cumulative_size = cumulative_size + data.length
				if cumulative_size > max_size
					frm.removeClass('is-uploading')
					_files[box_id] = []
					fs_t = _get_file_size_text cumulative_size
					ms_t = _get_file_size_text max_size
					tx = "File upload failed. Cumulative file size is: "
					tx += fs_t + "."
					tx += "Maximum allowed is "
					tx += ms_t + "."
					sAlert.error(tx)
					frm.addClass("is-error")
					return

				Meteor.call "upload_file", col, item, field, data, type,
					(err, rsp)->
						filesUp += 1

						if err
							sAlert.error('File upload failed: ' + err)
							frm.addClass('is-error')

						if filesUp==filesToRead
							frm.removeClass('is-uploading')
							self.uploaded.set _files[box_id][0].name
							_files[box_id] = []

						if not err
							sAlert.success('Upload done!')

			try
				fileReader.readAsBinaryString(file)
			catch error
				sAlert.error 'File upload failed: ' + error

		event.target.files = null

	'dragover .dropbox, dragenter .dropbox': (event)->
		get_form().addClass('is-dragover')

	'dragleave .dropbox, dragend .dropbox, drop .dropbox': (event)->
		get_form().removeClass('is-dragover')

	'dragexit .dropbox': (event) ->
		sAlert.info('exit')

	'click #restart': (event) ->
		console.log "restart"
		get_form().removeClass('is-uploading').removeClass('is-error')

