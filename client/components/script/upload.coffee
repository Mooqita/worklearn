###############################################################################
#
# Upload
#
##############################################

###############################################################################
_files = {}

###############################################################################
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

###############################################################################
_get_file_size_text = (byte) ->
	kb = Math.round(byte / 1024)
	if kb < 500
		return kb + " Kbyte"

	mb = Math.round(kb / 1024)
	if mb < 1
		return Math.round(kb / 1024, 2)

	return mb + " Mbyte"

###############################################################################
_get_meta_data = (box_id) ->
	if not box_id
		sAlert.error('_get_meta_data: Object does not have a box_id')

	res = _files[box_id]
	return res

###############################################################################
_set_meta_data = (self, box_id) ->
	max = self.max_size
	if not self.max_size
		max = 4*1024*1024

	if not box_id
		sAlert.error('_set_meta_data: Object does not have a box_id')

	_files[box_id] =
		files: []
		cumulative_size: 0
		max_size: max
		files_to_read: 0
		files_read: 0
		files_up: 0
		collection_name: self.collection_name
		upload_method: self.method
		item_id: self.item_id
		field: self.field

	res = _files[box_id]
	return res

###############################################################################
_set_files_to_read = (size, box_id) ->
	if not box_id
		sAlert.error('_set_files_to_read: Object does not have a box_id')

	_files[box_id].files_to_read = size

###############################################################################
_set_cumulative_size = (size, box_id) ->
	if not box_id
		sAlert.error('_set_cumulative_size: Object does not have a box_id')

	_files[box_id].cumulative_size = size

###############################################################################
_get_cumulative_size = (box_id) ->
	if not box_id
		sAlert.error('_get_cumulative_size: Object does not have a box_id')

	return _files[box_id].cumulative_size

###############################################################################
_increment_files_uploaded = (box_id) ->
	if not box_id
		sAlert.error('_increment_files_uploaded: Object does not have a box_id')

	_files[box_id].files_up = _files[box_id].files_up + 1

###############################################################################
_get_files_uploaded = (box_id) ->
	if not box_id
		sAlert.error('_get_files_uploaded: Object does not have a box_id')

	return _files[box_id].files_up

###############################################################################
_add_files = (n, box_id) ->
	if not box_id
		sAlert.error('_add_files: Object does not have a box_id')

	d = _files[box_id].files
	Array::push.apply d, n
	_files[box_id].files = d
	Session.set('_files', Math.random())

###############################################################################
_get_form = (box_id) ->
	if not box_id
		sAlert.error('_get_form: Object does not have a box_id')

	frm = $('#dropbox_' + box_id)
	return frm

###############################################################################
_upload_file = (self, file) ->
	box_id = self.box_id.get()

	if not box_id
		sAlert.error('_upload_file: Object does not have a box_id')

	frm = _get_form(box_id)
	fileReader = new FileReader()

	type = file.name.split(".")
	type = type[type.length-1]
	type = extension_to_mime(type)

	if not typeof file == "object"
		sAlert.error 'File upload failed not a valid file.'
		return

	fileReader.onload = (ev) ->
		raw = _get_file_data_from_event(ev)
		base = binary_string_to_base64(raw)
		data = "data:" + type + ";base64," + base
		meta = _get_meta_data(box_id)

		_set_cumulative_size meta.cumulative_size + data.length, box_id

		if _get_cumulative_size(box_id) > meta.max_size
			frm.removeClass('is-uploading')
			fs_t = _get_file_size_text _get_cumulative_size(box_id)
			ms_t = _get_file_size_text meta.max_size
			tx = "File upload failed. Cumulative file size is: "
			tx += fs_t + "."
			tx += "Maximum allowed is "
			tx += ms_t + "."
			sAlert.error(tx)
			frm.addClass("is-error")
			return

		Meteor.call meta.upload_method, meta.collection_name, meta.item_id, meta.field, data, type,
			(err, rsp)->
				_increment_files_uploaded box_id

				if err
					sAlert.error('File upload failed: ' + err)
					frm.addClass('is-error')

				if _get_files_uploaded(box_id) == meta.files_to_read
					frm.removeClass('is-uploading')
					self.uploaded.set _files[box_id].files[0].name
					_set_meta_data(self.data, box_id)

				if not err
					sAlert.success('Upload done!')
	try
		fileReader.readAsBinaryString(file)
	catch error
		sAlert.error 'File upload failed: ' + error

###############################################################################
# Upload
###############################################################################

###############################################################################
Template.upload.onCreated ->
	this.uploaded = new ReactiveVar("")

	files = Session.get('_files')

	if not files
		Session.set('_files', Math.random())

	box_id = Math.floor(Math.random()*10000000)
	this.box_id = new ReactiveVar(box_id)
	_set_meta_data(this.data, box_id)


###############################################################################
Template.upload.onRendered ->
	self = this
	box_id = self.box_id.get()

	submit_file = (event) ->
		event.preventDefault()
		frm = _get_form(box_id)

		if frm.hasClass('is-uploading')
			return false

		if !Meteor.userId()
			sAlert.error "Please login to upload files."
			return

		files = _get_meta_data(box_id).files

		if !files
			sAlert.error "No files selected to upload."
			return

		if files.length == 0
			sAlert.error ("No files selected to upload.")
			return

		frm.addClass('is-uploading').removeClass('is-error')

		_set_files_to_read files.length, box_id

		for file in files
			_upload_file(self, file)

		event.target.files = null

	id = "#dropbox_#{box_id}"
	$(id).on "submit", submit_file



###############################################################################
Template.upload.helpers
	uploaded: ->
		return Template.instance().uploaded.get()

	files: ->
		box_id = Template.instance().box_id.get()
		if Session.get('_files') != 0
			return _get_meta_data(box_id).files

	box_id: ->
		box_id = Template.instance().box_id.get()
		return box_id

	upload_style: ()->
		div = document.createElement('div')
		do_drag = (('draggable' in div) || ('ondragstart' in div && 'ondrop' in div))
		can_do = do_drag && 'FormData' in window && 'FileReader' in window
		can_do = true

		if can_do == true
			return('has-advanced-upload')
		else
			return('')


###############################################################################
Template.upload.events
	'dropped .dropbox': (event) ->
		box_id = Template.instance().box_id.get()
		n = event.originalEvent.dataTransfer.files
		_add_files n, box_id
		if not this.multiple
			_get_form(box_id).trigger('submit')

	'change .dropbox_file': (event)->
		box_id = Template.instance().box_id.get()
		n = event.target.files
		_add_files n, box_id
		if not this.multiple
			_get_form(box_id).trigger('submit')

	'dragover .dropbox, dragenter .dropbox': (event)->
		box_id = Template.instance().box_id.get()
		_get_form(box_id).addClass('is-dragover')

	'dragleave .dropbox, dragend .dropbox, drop .dropbox': (event)->
		box_id = Template.instance().box_id.get()
		_get_form(box_id).removeClass('is-dragover')


	'click .dropbox_restart': (event) ->
		box_id = Template.instance().box_id.get()
		_set_meta_data(Template.instance().data, box_id)
		_get_form(box_id).removeClass('is-uploading').removeClass('is-error')

	'dragexit .dropbox': (event) ->
		sAlert.info('exit')


